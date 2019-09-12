package bw_cps_code_generator.generator.factory

import de.fzi.sensidl.design.sensidl.dataRepresentation.DataSet
import java.util.HashMap
import java.util.List
import org.eclipse.emf.ecore.EObject
import de.fzi.bwcps.stream.bwcps_streams.entity.StreamRepository

/**
 * Main interface to create a new generation family
 * for a specific programming language.
 */
interface ICodeGenerator {
	
	/**
 	* Defines the method which calls the implementation
 	* for a language specific data transfer object.
 	* @param dataSet Contains all needed elements for the generation.
 	* @return a HashMap which maps the filename to generation-code 
 	* 		  represented as CharSequence.
 	*/
	def HashMap<String, CharSequence> generateDTO(StreamRepository streamRepo); 
	
	
}
