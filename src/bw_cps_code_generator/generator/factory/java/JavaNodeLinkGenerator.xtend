package bw_cps_code_generator.generator.factory.java

import bw_cps_code_generator.generator.BwcpsOutputConfigurationProvider
import bw_cps_code_generator.generator.GenerationUtil
import de.fzi.bwcps.stream.bwcps_streams.commons.NamedElement
import de.fzi.bwcps.stream.bwcps_streams.entity.StreamRepository
import java.util.HashMap
import java.util.List
import org.apache.log4j.Logger
import de.fzi.bwcps.stream.bwcps_streams.entity.NodeLink

class JavaNodeLinkGenerator extends JavaEntityGenerator {
	static val Logger logger = Logger.getLogger(JavaNodeLinkGenerator)
	val List<NodeLink> nodelinks

	new(List<NodeLink> nodelinks) {
		this.nodelinks = nodelinks
	}

	override generate() {
		logger.info("Generate node links.")
		val filesToGenerate = new HashMap
		filesToGenerate.put("NodeLink.java", generateInterfaceBody(nodelinks))
		logger.info("File: NodeLink.java was generated in " +
			BwcpsOutputConfigurationProvider.BWCPS_GEN)
		for (nodelink : nodelinks) {
			filesToGenerate.put(addFileExtensionTo(GenerationUtil.getEntityName(nodelink)),
			generateClassBody(GenerationUtil.getEntityName(nodelink), nodelink))
			logger.info("File: " + addFileExtensionTo(GenerationUtil.getEntityName(nodelink)) + " was generated in " +
			BwcpsOutputConfigurationProvider.BWCPS_GEN)
		}
		filesToGenerate
	}
	
	def generateInterfaceBody(List nodelink) {
		'''
			package nodes;
			import nodes.Node;
						
			/**
			* NodeLink Iterface
			*
			* @generated
			*/
			public interface NodeLink {
				
				public Node getSource();
				
				public Node getTarget();
				
				public void setSource();
				
				public void setTarget();
			}
		'''
	}
	
	override generateClassBody(String entityName, NamedElement stream) {
		'''
			package nodes;
			
			import nodes.NodeLink;
			/**
			* NodeLink: «entityName»
			*
			* @generated
			*/
				
			public class «entityName» implements Stream {
										
				private static final long serialVersionUID = 1L;
				
				«generateDataFields(stream)»
				
				«generateConstructor(stream, entityName)»
				
				
				«stream.generateMethods»
				
				«generateDataMethods(stream)»
				
			}
		'''
	}

	override generateDataMethods(NamedElement entity) {
		//
	}
	override generateConstructor(NamedElement entity, String className) {
		'''
				
			public «className»(Node source, Node target) {
				this.source = source;
				this.target = target;
			}
		'''
	}

	/** 
	 * Generates Methods
	 * 
	 */
	def generateMethods(StreamRepository repo) {
	}
	
	override generateDataFields(NamedElement entity) {
		'''
			private Node source;
			
			private Node target;
		'''
	}
	
	override generateMethods(NamedElement entity) {
	//	throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

}
