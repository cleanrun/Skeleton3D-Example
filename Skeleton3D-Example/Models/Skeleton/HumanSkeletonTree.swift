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
    private var rightArmSkeletonTree: ArmSkeletonTree
    
    /// The skeleton tree for the left arm
    private var leftArmSkeletonTree: ArmSkeletonTree
    
    /// The skeleton tree for the right leg
    private var rightLegSkeletonTree: LegSkeletonTree
    
    /// The skeleton tree for the left leg
    private var leftLegSkeletonTree: LegSkeletonTree
    
    /// The current scene view's root node
    private var mainSceneRootNode: SCNNode
    
    init(keypointsData: KeypointsData, rootNode: SCNNode) {
        self.keypointsData = keypointsData
        mainSceneRootNode = rootNode
        
        rightArmSkeletonTree = ArmSkeletonTree(keypoints: keypointsData.rightArmKeypoints, rootNode: mainSceneRootNode)
        leftArmSkeletonTree = ArmSkeletonTree(keypoints: keypointsData.leftArmKeypoints, rootNode: mainSceneRootNode)
        rightLegSkeletonTree = LegSkeletonTree(keypoints: keypointsData.rightLegKeypoints, rootNode: mainSceneRootNode)
        leftLegSkeletonTree = LegSkeletonTree(keypoints: keypointsData.leftLegKeypoints, rootNode: mainSceneRootNode)
    }
}
