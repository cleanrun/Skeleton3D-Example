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
    
    /// An Inverse Kinematics constraint for the parent node (in this case, the `armNode`)
    private var ikConstraint: SCNIKConstraint!
    
    /// The current scene view's root node
    private var mainSceneRootNode: SCNNode
    
    init(keypoints: [HumanKeypoint], rootNode: SCNNode, neckNode: SCNNode) {
        mainSceneRootNode = rootNode
        
        armNode = createKeypoint(position: keypoints[0])
        forearmNode = createKeypoint(position: keypoints[1])
        handNode = createKeypoint(position: keypoints[2])
        
        neckNode.addChildNode(armNode)
        armNode.addChildNode(forearmNode)
        forearmNode.addChildNode(handNode)
        
        armNode.position = neckNode.convertPosition(keypoints[0].getConvertedPosition(relativeTo: CGFloat(studioSize)), from: mainSceneRootNode)
        forearmNode.position = armNode.convertPosition(keypoints[1].getConvertedPosition(relativeTo: CGFloat(studioSize)), from: mainSceneRootNode)
        handNode.position = forearmNode.convertPosition(keypoints[2].getConvertedPosition(relativeTo: CGFloat(studioSize)), from: mainSceneRootNode)
        
        //setInverseKinematicsConstraint()
        
        //ikConstraint.targetPosition = keypoints[2].getConvertedPosition(relativeTo: CGFloat(studioSize))
    }
    
    /// Create an arm keypoint based on the provided position.
    /// - Parameter position: The 3 dimensional position of the node
    /// - Returns: Returns the created node
    private func createKeypoint(position: HumanKeypoint) -> SCNNode {
        let box = SCNSphere(radius: 0.25)
        let keypointNode = SCNNode(geometry: box)
        
        // FIXME: All of the nodes are colored to differentiate which node is which
        switch position.type {
        case .leftArm, .rightArm:
            keypointNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black.withAlphaComponent(0.9)
        case .leftForearm, .rightForearm:
            keypointNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(0.9)
        case .leftHand, .rightHand:
            keypointNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue.withAlphaComponent(0.9)
        default:
            break
        }
        
        return keypointNode
    }
    
    /// Setting up the constraints for Inverse Kinematics animation
    @available(iOS, obsoleted: 1.0,
               message: "Setting the IK constraints is not performed in the `ArmSkeletonTree` anymore, rather in `HumanSkeletonTree` object.")
    private func setInverseKinematicsConstraint() {
        ikConstraint = .inverseKinematicsConstraint(chainRootNode: armNode)
        handNode.constraints = [ikConstraint]
        //ikConstraint.setMaxAllowedRotationAngle(45, forJoint: forearmNode)
    }
}
