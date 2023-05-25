//
//  HumanSkeletonTree.swift
//  Skeleton3D-Example
//
//  Created by cleanmac on 22/05/23.
//

import SceneKit

final class HumanSkeletonTree {
    
    /// All of the keypoints for the human skeleton
    private var keypointsData: KeypointsData!
    
    /// The skeleton tree for the right arm
    private(set) var rightArmSkeletonTree: ArmSkeletonTree!
    
    /// The skeleton tree for the left arm
    private(set) var leftArmSkeletonTree: ArmSkeletonTree!
    
    /// The skeleton tree for the right leg
    //private(set) var rightLegSkeletonTree: LegSkeletonTree
    
    /// The skeleton tree for the left leg
    //private(set) var leftLegSkeletonTree: LegSkeletonTree
    
    /// The node of the human's neck. This will be the parent node for both of the arms
    private var neckNode: SCNNode!
    
    /// The node of the human's spine
    private var spineNode: SCNNode!
    
    /// The node of the human's neck. This will be the parent node for both of the legs.
    /// This will also be the main parent node of all of the nodes of the human keypoints
    private var hipNode: SCNNode!
    
    /// An IK constraint for the right arm
    private var rightIkConstraint: SCNIKConstraint!
    
    /// An IK constraint for the left arm
    private var leftIkConstraint: SCNIKConstraint!
    
    /// The current scene view's root node
    private var mainSceneRootNode: SCNNode
    
    init(keypointsData: KeypointsData, rootNode: SCNNode) {
        self.keypointsData = keypointsData
        mainSceneRootNode = rootNode
        
        setInitialRootNodes()
        
        // The IK constraints for both of the arms is based on the neck node
        rightIkConstraint = .inverseKinematicsConstraint(chainRootNode: neckNode)
        leftIkConstraint = .inverseKinematicsConstraint(chainRootNode: neckNode)
        
        // Initializing the arm and leg node tree
        rightArmSkeletonTree = ArmSkeletonTree(keypoints: keypointsData.rightArmKeypoints, rootNode: mainSceneRootNode, neckNode: neckNode)
        leftArmSkeletonTree = ArmSkeletonTree(keypoints: keypointsData.leftArmKeypoints, rootNode: mainSceneRootNode, neckNode: neckNode)
        
        // Setting the IK constraints for both of the arms
        rightArmSkeletonTree.handNode.constraints = [rightIkConstraint]
        leftArmSkeletonTree.handNode.constraints = [leftIkConstraint]
    }
    
    /// Setting the parent nodes
    private func setInitialRootNodes() {
        
        // Creating the hip node
        let hipSphere = SCNSphere(radius: 0.25)
        hipSphere.firstMaterial?.diffuse.contents = UIColor.cyan.withAlphaComponent(0.9)
        hipNode = SCNNode(geometry: hipSphere)
        hipNode.position = keypointsData.getKeypoint(type: .hips)!.getConvertedPosition(relativeTo: CGFloat(studioSize))
        mainSceneRootNode.addChildNode(hipNode)
        
        // Creating the spine node
        let spineSphere = SCNSphere(radius: 0.25)
        spineSphere.firstMaterial?.diffuse.contents = UIColor.brown.withAlphaComponent(0.9)
        spineNode = SCNNode(geometry: spineSphere)
        spineNode.position = hipNode.convertPosition(keypointsData.getKeypoint(type: .spine5)!.getConvertedPosition(relativeTo: CGFloat(studioSize)),
                                                     from: mainSceneRootNode)
        hipNode.addChildNode(spineNode)
        
        // Creating the neck node
        let neckSphere = SCNSphere(radius: 0.25)
        neckSphere.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.9)
        neckNode = SCNNode(geometry: neckSphere)
        neckNode.position = spineNode.convertPosition(keypointsData.getKeypoint(type: .neck1)!.getConvertedPosition(relativeTo: CGFloat(studioSize)),
                                                    from: mainSceneRootNode)
        spineNode.addChildNode(neckNode)
    }
    
    /// Changing both of the arms position based on a new vector
    /// - Parameters:
    ///   - rightVector: The vector position for the right arm
    ///   - leftVector: The vector position for the left arm
    private func changeHandPosition(_ rightVector: SCNVector3, _ leftVector: SCNVector3) {
        //SCNTransaction.animateEaseInOut(duration: 0.5) { [unowned self] in
            rightIkConstraint.targetPosition = SCNVector3Make(rightVector.x + 0.5, rightVector.y, rightVector.z)
            leftIkConstraint.targetPosition = leftVector
        //}
    }
    
    /// Sets a new keypoints data, and change all of the required position based on the new data
    /// - Parameter newData: A new keypoint data for setting the new positions
    func changePositions(using newData: KeypointsData) {
        keypointsData = newData
        
        //neckNode.position = keypointsData.getKeypoint(type: .neck1)!.getConvertedPosition(relativeTo: CGFloat(studioSize))
        spineNode.position = hipNode.convertPosition(keypointsData.getKeypoint(type: .spine5)!.getConvertedPosition(relativeTo: CGFloat(studioSize)),
                                                     from: mainSceneRootNode)
        //hipNode.position = keypointsData.getKeypoint(type: .hips)!.getConvertedPosition(relativeTo: CGFloat(studioSize))
        
        changeHandPosition(keypointsData.leftArmKeypoints[2].getConvertedPosition(relativeTo: CGFloat(studioSize)),
                           keypointsData.leftArmKeypoints[2].getConvertedPosition(relativeTo: CGFloat(studioSize)))
    }
    
}
