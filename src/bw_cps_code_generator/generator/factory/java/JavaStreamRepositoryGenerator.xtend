package bw_cps_code_generator.generator.factory.java

import bw_cps_code_generator.generator.BwcpsOutputConfigurationProvider
import bw_cps_code_generator.generator.GenerationUtil
import de.fzi.bwcps.stream.bwcps_streams.commons.NamedElement
import de.fzi.bwcps.stream.bwcps_streams.entity.StreamRepository
import java.util.HashMap
import org.apache.log4j.Logger

class JavaStreamRepositoryGenerator extends JavaEntityGenerator {
	static val Logger logger = Logger.getLogger(JavaStreamRepositoryGenerator)
	val StreamRepository streamRepo

	new(StreamRepository streamRepo) {
		this.streamRepo = streamRepo
	}

	override generate() {
		logger.info("Start with code-generation of the Stream Repository.")
		val filesToGenerate = new HashMap

		filesToGenerate.put(addFileExtensionTo(GenerationUtil.getEntityName(streamRepo)),
			generateClassBody(GenerationUtil.getEntityName(streamRepo), streamRepo))
			
		logger.info("File: " + addFileExtensionTo(GenerationUtil.getEntityName(streamRepo)) + " was generated in " +
			BwcpsOutputConfigurationProvider.BWCPS_GEN)

		filesToGenerate
	}

	override generateClassBody(String repoName, NamedElement repo) {

		'''
			package streamrepository;
			
			/**
			* «GenerationUtil.getClassName(repo)»: «repoName»
			*
			* @generated
			*/
				
			public class «repoName» {
										
				private static final long serialVersionUID = 1L;
				
				«generateDataFields(repo)»
				
				«generateConstructor(repo, repoName)»
				
				
				«repo.generateMethods»
				
				«generateDataMethods(repo)»
				
			}
		'''
	}

	override generateDataMethods(NamedElement entity) {
		
	}

	override generateConstructor(NamedElement entity, String className) {
		'''
				
			public «className»() {
					
			«IF streamRepo.streams != null»
					this.streams = new java.util.ArrayList<streams.Stream>();
						
				«FOR s: streamRepo.streams »
					this.streams.put(new streams.«GenerationUtil.toNameUpper(s)»());
						
				«ENDFOR»
			«ENDIF» 
			«IF streamRepo.container != null»
					this.containers = new java.util.ArrayList<nodes.NodeContainer>();
						
				«FOR n: streamRepo.container »
					this.containers.put(new nodes.«GenerationUtil.toNameUpper(n)»());
						
				«ENDFOR»
			«ENDIF» 
			«IF streamRepo.nodes != null»
					this.nodes = new java.util.ArrayList<nodes.Node>();
						
				«FOR n: streamRepo.nodes »
					this.streams.put(new «GenerationUtil.toNameUpper(n)»());
						
				«ENDFOR»
			«ENDIF» 
«««			«IF streamRepo.nodelinks != null»
«««				this.nodelinks = new java.util.ArrayList<NodeLink>();
«««				«FOR n: streamRepo.nodelinks »
«««					this.nodelinks.put(new NodeLink(«n.name»));
«««				«ENDFOR»
«««			«ENDIF» 
«««			«IF streamRepo.nodeTypes != null»
«««				this.nodeTypes = new java.util.ArrayList<NodeType>();
«««				«FOR n: streamRepo.nodes »
«««					this.streams.put(new Node(«n.name»));
«««				«ENDFOR»
«««			«ENDIF» 			
			}
		'''
	}

	def generateDataFields(StreamRepository streamRepo) {

	}

	/** 
	 * Generates Methods
	 * 
	 */
	def generateMethods(StreamRepository repo) {
	}

	
	override generateDataFields(NamedElement entity) {
		'''
			«IF streamRepo.streams != null»
					java.util.ArrayList<streams.Stream> streams;
						
			«ENDIF» 
			«IF streamRepo.container != null»
					java.util.ArrayList<nodes.NodeContainer> containers;
						
			«ENDIF» 
			«IF streamRepo.nodes != null»
					java.util.ArrayList<nodes.Node> nodes;
						
			«ENDIF» 
«««			«IF streamRepo.nodelinks != null»
«««				this.nodelinks = new java.util.ArrayList<NodeLink>();
«««				«FOR n: streamRepo.nodelinks »
«««					this.nodelinks.put(new NodeLink(«n.name»));
«««				«ENDFOR»
«««			«ENDIF» 
«««			«IF streamRepo.nodeTypes != null»
«««				this.nodeTypes = new java.util.ArrayList<NodeType>();
«««				«FOR n: streamRepo.nodes »
«««					this.streams.put(new Node(«n.name»));
«««				«ENDFOR»
«««			«ENDIF» 	
		'''
	}
	
	override generateMethods(NamedElement entity) {
//
	}

}
