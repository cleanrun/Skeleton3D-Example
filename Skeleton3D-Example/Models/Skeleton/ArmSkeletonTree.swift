//
//  ArmSkeletonTree.swift
//  Skeleton3D-Example
//
//  Created by cleanmac on 22/05/23.
//

import SceneKit

final class ArmSkeletonTree {
    
    /// The arm keypoint node, this will act as the parent node of all the arm skeleton nodes
    private(set) var armNode: SCNNode!
    
    /// The forearm keypoint node
    private(set) var forearmNode: SCNNode!
    
    /// The hand keypoint node
    private(set) var handNode: SCNNode!
    
    /// The current scene view's root node
    private var mainSceneRootNode: SCNNode
    
    init(keypoints: [HumanKeypoint], rootNode: SCNNode) {
        mainSceneRootNode = rootNode
        
        armNode = createKeypoint(position: keypoints[0])
        forearmNode = createKeypoint(position: keypoints[1])
        handNode = createKeypoint(position: keypoints[2])
        
        rootNode.addChildNode(armNode)
        armNode.addChildNode(forearmNode)
        forearmNode.addChildNode(handNode)
        
        armNode.position = keypoints[0].getConvertedPosition(relativeTo: CGFloat(studioSize))
        forearmNode.position = armNode.convertPosition(keypoints[1].getConvertedPosition(relativeTo: CGFloat(studioSize)), from: mainSceneRootNode)
        handNode.position = forearmNode.convertPosition(keypoints[2].getConvertedPosition(relativeTo: CGFloat(studioSize)), from: mainSceneRootNode)
    }
    
    /// Create an arm keypoint based on the provided position.
    /// - Parameter position: The 3 dimensional position of the node
    /// - Returns: Returns the created node
    private func createKeypoint(position: HumanKeypoint) -> SCNNode {
        let box = SCNBox(width: 0.3, height: 0.3, length: 0.3, chamferRadius: 0)
        let keypointNode = SCNNode(geometry: box)
        
        // FIXME: All of the nodes are colored to differentiate which node is which
        switch position.type {
        case .leftArm, .rightArm:
            keypointNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black.withAlphaComponent(0.5)
        case .leftForearm, .rightForearm:
            keypointNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(0.5)
        case .leftHand, .rightHand:
            keypointNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue.withAlphaComponent(0.5)
        default:
            break
        }
        
        return keypointNode
    }
}
