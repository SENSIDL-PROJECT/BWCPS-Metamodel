package de.fzi.bwcpsgenerator.ui.wizard;

import java.io.FileNotFoundException;
import java.net.URL;

import org.apache.log4j.Logger;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.Platform;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.resource.ImageDescriptor;
import org.eclipse.jface.wizard.Wizard;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.internal.util.BundleUtility;
import org.osgi.framework.Bundle;

import de.fzi.bwcpsgenerator.exception.MetamodelException;
import de.fzi.bwcpsgenerator.exception.NoBwcpsFileException;
import de.fzi.bwcpsgenerator.generator.BwCPSConstants;
import de.fzi.bwcpsgenerator.ui.handler.ErrorDialogHandler;
import de.fzi.bwcpsgenerator.ui.handler.GenerationHandler;
import de.fzi.bwcpsgenerator.ui.handler.SettingsHandler;


@SuppressWarnings("restriction")
public class BwcpsWizard extends Wizard {
	protected BwcpsWizardPage bwcpsWizardPage;
	private String modelPath;
	private String path;
	private String language;
	private Resource bwcpsmodel;
	private static Logger logger = Logger.getLogger(BwcpsWizard.class);
	/**
	 * Constructor
	 * 
	 * @param modelPath
	 *            the path for the model path text field in the
	 *            SensidlWizardPage
	 * @param path
	 *            the path for the path text field in the SensidlWizardPage
	 * @param language
	 *            the generation language
	 */
	public BwcpsWizard(String modelPath, String path, String language, Resource bwcpsmodel) {
		this.modelPath = modelPath;
		this.path = path;
		this.language = language;
		this.bwcpsmodel = bwcpsmodel;
	}
	
	@Override
	public void addPages() {
		Bundle bundle = Platform.getBundle(BwCPSConstants.BUNDLE_NAME);
		URL fullPathString = BundleUtility.find(bundle, "images/BW-CPS.png");
		bwcpsWizardPage = new BwcpsWizardPage("BW-CPS - Code Generation", "BW-CPS - Code Generation",
				ImageDescriptor.createFromURL(fullPathString), modelPath, path, language);
		addPage(bwcpsWizardPage);

	}
	
	@Override
	public boolean performFinish() {
		String modelPath = null;
		if (bwcpsWizardPage.getTextModelPath().startsWith("platform:/resource")) {
			modelPath = bwcpsWizardPage.getTextModelPath().replace("platform:/resource",
					ResourcesPlugin.getWorkspace().getRoot().getLocation().toString());
		} else {
			modelPath = bwcpsWizardPage.getTextModelPath();
		}

		String path = null;
		if (bwcpsWizardPage.getTextPath().startsWith("platform:/resource")) {
			path = bwcpsWizardPage.getTextPath().replace("platform:/resource",
					ResourcesPlugin.getWorkspace().getRoot().getLocation().toString());
		} else {
			path = bwcpsWizardPage.getTextPath();
		}

		// Exception handling to give user feedback
		ErrorDialogHandler errorHandler = new ErrorDialogHandler();
		try {
			// start the generator with the GenerationHandler
			GenerationHandler.generate(path, modelPath, bwcpsWizardPage.getLanguage(), bwcpsmodel);
			MessageDialog.openInformation(new Shell(), "Info", "The code was successfully generated");

		} catch (FileNotFoundException ex) {
			errorHandler.execute(new Shell(), ex);
			return false;
		} catch (NoBwcpsFileException ex) {
			errorHandler.execute(new Shell(), ex);
			return false;
		} catch (MetamodelException ex) {
			errorHandler.execute(new Shell(), ex);
			return false;
		}catch (Exception ex) {
			logger.info(ex.getStackTrace());
			errorHandler.execute(new Shell(), ex);
			return false;
		}

		SettingsHandler.saveSettings(bwcpsWizardPage.getTextModelPath(), bwcpsWizardPage.getTextPath(),
				bwcpsWizardPage.getLanguage());
		return true;
	}
}
