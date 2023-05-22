//
//  LegSkeletonTree.swift
//  Skeleton3D-Example
//
//  Created by cleanmac on 22/05/23.
//

import SceneKit

final class LegSkeletonTree {
    
    /// The upleg keypoint node, this will act as the parent node of all leg skeleton nodes
    private(set) var uplegNode: SCNNode!
    
    /// The leg keypoint node
    private(set) var legNode: SCNNode!
    
    /// The foot keypoint node
    private(set) var footNode: SCNNode!
    
    private var mainSceneRootNode: SCNNode
    
    init(keypoints: [HumanKeypoint], rootNode: SCNNode) {
        mainSceneRootNode = rootNode
        
        uplegNode = createKeypoint(position: keypoints[0])
        legNode = createKeypoint(position: keypoints[1])
        footNode = createKeypoint(position: keypoints[2])
        
        rootNode.addChildNode(uplegNode)
        uplegNode.addChildNode(legNode)
        legNode.addChildNode(footNode)
        
        uplegNode.position = keypoints[0].getConvertedPosition(relativeTo: CGFloat(studioSize))
        legNode.position = uplegNode.convertPosition(keypoints[1].getConvertedPosition(relativeTo: CGFloat(studioSize)), from: mainSceneRootNode)
        footNode.position = legNode.convertPosition(keypoints[2].getConvertedPosition(relativeTo: CGFloat(studioSize)), from: mainSceneRootNode)
    }
    
    /// Create an leg keypoint based on the provided position.
    /// - Parameter position: The 3 dimensional position of the node
    /// - Returns: Returns the created node
    private func createKeypoint(position: HumanKeypoint) -> SCNNode {
        let box = SCNBox(width: 0.3, height: 0.3, length: 0.3, chamferRadius: 0)
        let keypointNode = SCNNode(geometry: box)
        
        // FIXME: All of the nodes are colored to differentiate which node is which
        switch position.type {
        case .leftUpleg, .rightUpleg:
            keypointNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
        case .leftLeg, .rightLeg:
            keypointNode.geometry?.firstMaterial?.diffuse.contents = UIColor.green.withAlphaComponent(0.5)
        case .leftFoot, .rightFoot:
            keypointNode.geometry?.firstMaterial?.diffuse.contents = UIColor.brown.withAlphaComponent(0.5)
        default:
            break
        }
        
        return keypointNode
    }
}
