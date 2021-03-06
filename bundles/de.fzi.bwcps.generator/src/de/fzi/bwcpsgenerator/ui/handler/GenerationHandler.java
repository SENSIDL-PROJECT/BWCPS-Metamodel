package de.fzi.bwcpsgenerator.ui.handler;

import java.io.File;
import java.io.FileNotFoundException;

import org.apache.commons.io.FilenameUtils;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.xtext.generator.JavaIoFileSystemAccess;
import org.eclipse.xtext.parser.IEncodingProvider;
import org.eclipse.xtext.service.AbstractGenericModule;

import com.google.inject.Guice;

import de.fzi.bwcpsgenerator.exception.MetamodelException;
import de.fzi.bwcpsgenerator.exception.NoBwcpsFileException;
import de.fzi.bwcpsgenerator.generator.BwCPSConstants;
import de.fzi.bwcpsgenerator.generator.BwCPSExtentions;
import de.fzi.bwcpsgenerator.generator.BwcpsGenerator;
import de.fzi.bwcpsgenerator.generator.BwcpsStandaloneSetup;
public class GenerationHandler {
	private static BwCPSConstants.GenerationLanguage generationLanguage = BwCPSConstants.GenerationLanguage.NONE;
	private static BwcpsGenerator generator;
	private GenerationHandler() {

	}

	/**
	 * Start the Code generator
	 * 
	 * @param path      the path where the files will be saves
	 * @param modelPath the path to the model form with the code will be generated
	 * @param language  the language in which the Code will be generated
	 * @return true if the code was generated
	 * @throws NoBwcpsFileException   Throws this Exception when the given file is
	 *                               not a bwcps file
	 * @throws FileNotFoundException Throws this Exception when there is no file at
	 *                               the given path
	 * 
	 */
	public static boolean generate(String path, String modelPath, String language, Resource bwcpsmodel)
			throws NoBwcpsFileException, FileNotFoundException, MetamodelException {
		
		
		setGenerationLanguage(language);
		new BwcpsStandaloneSetup().register();
		
		// get resource
		Resource resource = null;
		if (bwcpsmodel != null) {
			resource = bwcpsmodel;
		} else {
			ResourceSet rs = new ResourceSetImpl();
			File file = new File(modelPath);

			// Exception handling for not existing input files
			if (!file.exists()) {
				throw new FileNotFoundException("File not found");
			}
			// Exception handling for input files in the wrong format
			if (!BwCPSExtentions.contains(FilenameUtils.getExtension(modelPath))) {
				throw new NoBwcpsFileException("No BWCPS file found");
			}

			resource = rs.getResource(URI.createURI(file.toURI().toString()), true);
		}


		// Use the JavaIoFileSystemAccess and set the path
//		JavaIoFileSystemAccess fsa = injector.getInstance(JavaIoFileSystemAccess.class);
		final JavaIoFileSystemAccess fsa = new JavaIoFileSystemAccess();
		fsa.setOutputPath(path);
		
		//set up the generator
		generator = new BwcpsGenerator();
		generator.setGenerationLanguage(generationLanguage);
		
		// inject fsa
		Guice.createInjector(new AbstractGenericModule() {
			@SuppressWarnings("unused")
			public Class<? extends IEncodingProvider> bindIEncodingProvider() {
				return IEncodingProvider.Runtime.class;
			}
		}).injectMembers(fsa);

				// generate
		generator.doGenerate(resource, fsa);
		
		return false;
	}

	/**
	 * set the Generation language
	 * 
	 * @param language A String with the language
	 */
	private static void setGenerationLanguage(String language) {
		switch (language) {
		case "Java":
			generationLanguage = BwCPSConstants.GenerationLanguage.JAVA;
			break;
		case "Osgi Bundles":
			generationLanguage = BwCPSConstants.GenerationLanguage.OSGI_BUNDLES;
			break;
		case "Kura Bundles":
			generationLanguage = BwCPSConstants.GenerationLanguage.KURA_BUNDLES;
			break;
		case "All":
			generationLanguage = BwCPSConstants.GenerationLanguage.ALL;
			break;
		default:
			generationLanguage = BwCPSConstants.GenerationLanguage.NONE;
			break;
		}

	}


}
