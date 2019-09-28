package bw_cps_code_generator.generator.generationstep


import bw_cps_code_generator.generator.generationstep.GenerationStep
import java.util.HashMap
import java.util.List
import bw_cps_code_generator.generator.BwCPSConstants.GenerationLanguage
import bw_cps_code_generator.generator.elementfilter.ElementFilter
import de.fzi.bwcps.stream.bwcps_streams.entity.StreamRepository
import bw_cps_code_generator.generator.IExecuter
import bw_cps_code_generator.generator.factory.java.JavaGenerator
import bw_cps_code_generator.generator.factory.kuracomponents.JavaComponentGenerator
import de.fzi.bwcps.stream.bwcps_streams.commons.NamedElement
import de.fzi.bwcps.stream.bwcps_streams.entity.NodeContainer

class DTOGenerationStep extends GenerationStep {

	private NamedElement element

	/**
	 * The constructor calls the needed data filtered by a
	 * concrete element-filter.
	 * @param filter - represents a base filter which can be substituted by a specific
	 * 				   subclass that filters a particular set of elements.	
	 */
	new(NamedElement element) {
		this.element = element
	}

	new(ElementFilter filter) {
		this.element = filter.filterData()
	}
	/**
	 * @see GenerationStep#startGenerationTask()
	 */
	override startGenerationTask() {
	
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
				val JavaGenerator jgenerator = new JavaGenerator(GenerationLanguage.ALL)
				val JavaComponentGenerator kgenerator = new JavaComponentGenerator(javaPackagePrefix)

				filesToGenerate => [
					putAll(jgenerator.generateDTO(this.element as StreamRepository))
					putAll(kgenerator.generateDTO(this.element as NodeContainer))
				
				]
			])
			put(GenerationLanguage.KURA_PROJECT, [
				val JavaComponentGenerator generator = new JavaComponentGenerator(javaPackagePrefix)
				resetFilesToGenerate
				filesToGenerate => [
					putAll(generator.generateDTO(this.element as NodeContainer))
				]
				
			])
			put(GenerationLanguage.JAVA, [
				val JavaGenerator generator = new JavaGenerator(GenerationLanguage.JAVA)
				filesToGenerate => [
					putAll(generator.generateDTO(this.element as StreamRepository))
				]
			])
			
			put(GenerationLanguage.NONE, [
				
			])
			
		]
	}
	
}
