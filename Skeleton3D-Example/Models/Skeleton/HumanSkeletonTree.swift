//
//  HumanSkeletonTree.swift
//  Skeleton3D-Example
//
//  Created by cleanmac on 22/05/23.
//

import SceneKit

final class HumanSkeletonTree {
    
    /// All of the keypoints for the human skeleton
    private var keypointsData: KeypointsData
    
    /// The skeleton tree for the right arm
    private(set) var rightArmSkeletonTree: ArmSkeletonTree
    
    /// The skeleton tree for the left arm
    //private(set) var leftArmSkeletonTree: ArmSkeletonTree
    
    /// The skeleton tree for the right leg
    //private(set) var rightLegSkeletonTree: LegSkeletonTree
    
    /// The skeleton tree for the left leg
    //private(set) var leftLegSkeletonTree: LegSkeletonTree
    
    private var neckNode: SCNNode!
    private var ikConstraint: SCNIKConstraint!
    
    /// The current scene view's root node
    private var mainSceneRootNode: SCNNode
    
    init(keypointsData: KeypointsData, rootNode: SCNNode) {
        self.keypointsData = keypointsData
        mainSceneRootNode = rootNode
        
        //rightArmSkeletonTree = ArmSkeletonTree(keypoints: keypointsData.rightArmKeypoints, rootNode: mainSceneRootNode, neckNode: neckNode)
        //leftArmSkeletonTree = ArmSkeletonTree(keypoints: keypointsData.leftArmKeypoints, rootNode: mainSceneRootNode)
        //rightLegSkeletonTree = LegSkeletonTree(keypoints: keypointsData.rightLegKeypoints, rootNode: mainSceneRootNode)
        //leftLegSkeletonTree = LegSkeletonTree(keypoints: keypointsData.leftLegKeypoints, rootNode: mainSceneRootNode)
        
        let box = SCNSphere(radius: 0.25)
        box.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.9)
        neckNode = SCNNode(geometry: box)
        neckNode.position = keypointsData.keypoints[KeypointJointType.neck1.rawValue].getConvertedPosition(relativeTo: CGFloat(studioSize))
        mainSceneRootNode.addChildNode(neckNode)
        
        ikConstraint = .inverseKinematicsConstraint(chainRootNode: neckNode)
        
        rightArmSkeletonTree = ArmSkeletonTree(keypoints: keypointsData.rightArmKeypoints, rootNode: mainSceneRootNode, neckNode: neckNode)
        
        rightArmSkeletonTree.handNode.constraints = [ikConstraint]
        rightArmSkeletonTree.forearmNode.constraints = [ikConstraint]
    }
    
    func changeHandPosition(_ vector: SCNVector3) {
        SCNTransaction.animateEaseInOut(duration: 0.5) { [unowned self] in
            ikConstraint.targetPosition = vector
            //handNode.position = forearmNode.convertPosition(vector, from: mainSceneRootNode)
        }
    }
    
    
}
