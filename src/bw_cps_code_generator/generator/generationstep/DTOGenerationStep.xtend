package bw_cps_code_generator.generator.generationstep

import bw_cps_code_generator.generator.generationstep.GenerationStep
import java.util.HashMap
import java.util.List
import bw_cps_code_generator.generator.BwCPSConstants.GenerationLanguage
import de.fzi.bwcps.stream.bwcps_streams.entity.StreamRepository
import bw_cps_code_generator.generator.IExecuter
import bw_cps_code_generator.generator.factory.java.JavaGenerator
import de.fzi.bwcps.stream.bwcps_streams.commons.NamedElement
import de.fzi.bwcps.stream.bwcps_streams.entity.NodeContainer
import de.fzi.bwcps.stream.bwcps_streams.entity.NodeLink
import bw_cps_code_generator.generator.metamodelmanager.ElementManager
import bw_cps_code_generator.generator.factory.components.ComponentGenerator

class DTOGenerationStep extends GenerationStep {

	NamedElement element
	List<NodeLink> nodelinks
	
	/**
	 * The constructor calls the needed data filtered by a
	 * concrete element-filter.
	 * @param filter - represents a base filter which can be substituted by a specific
	 * 				   subclass that filters a particular set of elements.	
	 */
	new(NodeContainer element, List<NodeLink> nodelinks) {
		this.element = element
		this.nodelinks = nodelinks
	}

	new(ElementManager filter) {
		this.element = filter.filterData()
	}
	/**
	 * @see GenerationStep#startGenerationTask()
	 */
	override startGenerationTask() {
		if(!skipProject)
			this.resourcesToGenerateMapping.get(generationLanguage).execute
		
	}
	
	/**
	 * Initializes a HashMap that maps each {@link GenerationLanguage} to a
	 * {@link IExecuter} object.
	 * @return the HashMap {@link GenerationLanguage} to {@link IExecuter}
	 */
	private def getResourcesToGenerateMapping() {
		return new HashMap<GenerationLanguage, IExecuter> => [
			put(GenerationLanguage.ALL, [
				val JavaGenerator jgenerator = new JavaGenerator(GenerationLanguage.ALL, javaPackagePrefix)
				val ComponentGenerator kgenerator = new ComponentGenerator(javaPackagePrefix)

				filesToGenerate => [
					putAll(jgenerator.generateDTO(this.element as StreamRepository))
					putAll(kgenerator.generateDTO(this.element as NodeContainer, nodelinks))
				
				]
			])
			put(GenerationLanguage.OSGI_BUNDLES, [
				val ComponentGenerator kgenerator = new ComponentGenerator(javaPackagePrefix)
				
				resetFilesToGenerate
				filesToGenerate => [
					putAll(kgenerator.generateDTO(this.element as NodeContainer, nodelinks))
				]
				
			])
			put(GenerationLanguage.JAVA, [
				val JavaGenerator generator = new JavaGenerator(GenerationLanguage.JAVA, javaPackagePrefix)
				filesToGenerate => [
					putAll(generator.generateDTO(this.element as StreamRepository))
				]
			])
			
			put(GenerationLanguage.NONE, [
				
			])
			
		]
	}
	
}
