package bw_cps_code_generator.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess

/**
 * Interface for the SensIDL code generator.
 * 
 * @author Dominik Werle
 * @author Emre Taspolatoglu
 */
interface IBwcpsCodeGenerator {
	/**
	 * @param input Represents he input of the {@link DataModel}.
	 * @param fsa The file system access is used to generate files.
	 */
	def void doGenerate(Resource input, IFileSystemAccess fsa);
}
