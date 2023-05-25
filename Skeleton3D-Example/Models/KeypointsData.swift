//
//  KeypointsData.swift
//  Skeleton3D-Example
//
//  Created by cleanmac on 16/05/23.
//

import Foundation

struct KeypointsData: Decodable {
    let id: Int
    private let keypoints3d: [[Float]]
    private var keypoints: [HumanKeypoint] {
        keypoints3d.enumerated().map { index, element in
            HumanKeypoint(type: index, x: element[0], y: element[1], z: element[2])
        }
    }
    
    /// A generated array of keypoints for the right arm group
    var rightArmKeypoints: [HumanKeypoint] {
        [
            HumanKeypoint(type: KeypointJointType.rightArm.rawValue,
                          x: keypoints3d[KeypointJointType.rightArm.rawValue][0],
                          y: keypoints3d[KeypointJointType.rightArm.rawValue][1],
                          z: keypoints3d[KeypointJointType.rightArm.rawValue][2]),
            HumanKeypoint(type: KeypointJointType.rightForearm.rawValue,
                          x: keypoints3d[KeypointJointType.rightForearm.rawValue][0],
                          y: keypoints3d[KeypointJointType.rightForearm.rawValue][1],
                          z: keypoints3d[KeypointJointType.rightForearm.rawValue][2]),
            HumanKeypoint(type: KeypointJointType.rightHand.rawValue,
                          x: keypoints3d[KeypointJointType.rightHand.rawValue][0],
                          y: keypoints3d[KeypointJointType.rightHand.rawValue][1],
                          z: keypoints3d[KeypointJointType.rightHand.rawValue][2]),
        ]
    }
    
    /// A generated array of keypoints for the left arm group
    var leftArmKeypoints: [HumanKeypoint] {
        [
            HumanKeypoint(type: KeypointJointType.leftArm.rawValue,
                          x: keypoints3d[KeypointJointType.leftArm.rawValue][0],
                          y: keypoints3d[KeypointJointType.leftArm.rawValue][1],
                          z: keypoints3d[KeypointJointType.leftArm.rawValue][2]),
            HumanKeypoint(type: KeypointJointType.leftForearm.rawValue,
                          x: keypoints3d[KeypointJointType.leftForearm.rawValue][0],
                          y: keypoints3d[KeypointJointType.leftForearm.rawValue][1],
                          z: keypoints3d[KeypointJointType.leftForearm.rawValue][2]),
            HumanKeypoint(type: KeypointJointType.leftHand.rawValue,
                          x: keypoints3d[KeypointJointType.leftHand.rawValue][0],
                          y: keypoints3d[KeypointJointType.leftHand.rawValue][1],
                          z: keypoints3d[KeypointJointType.leftHand.rawValue][2]),
        ]
    }
    
    /// A generated array of keypoints for the right leg group
    var rightLegKeypoints: [HumanKeypoint] {
        [
            HumanKeypoint(type: KeypointJointType.rightUpleg.rawValue,
                          x: keypoints3d[KeypointJointType.rightUpleg.rawValue][0],
                          y: keypoints3d[KeypointJointType.rightUpleg.rawValue][1],
                          z: keypoints3d[KeypointJointType.rightUpleg.rawValue][2]),
            HumanKeypoint(type: KeypointJointType.rightLeg.rawValue,
                          x: keypoints3d[KeypointJointType.rightLeg.rawValue][0],
                          y: keypoints3d[KeypointJointType.rightLeg.rawValue][1],
                          z: keypoints3d[KeypointJointType.rightLeg.rawValue][2]),
            HumanKeypoint(type: KeypointJointType.rightFoot.rawValue,
                          x: keypoints3d[KeypointJointType.rightFoot.rawValue][0],
                          y: keypoints3d[KeypointJointType.rightFoot.rawValue][1],
                          z: keypoints3d[KeypointJointType.rightFoot.rawValue][2])
        ]
    }
    
    /// A generated array of keypoints for the left leg group
    var leftLegKeypoints: [HumanKeypoint] {
        [
            HumanKeypoint(type: KeypointJointType.leftUpleg.rawValue,
                          x: keypoints3d[KeypointJointType.leftUpleg.rawValue][0],
                          y: keypoints3d[KeypointJointType.leftUpleg.rawValue][1],
                          z: keypoints3d[KeypointJointType.leftUpleg.rawValue][2]),
            HumanKeypoint(type: KeypointJointType.leftLeg.rawValue,
                          x: keypoints3d[KeypointJointType.leftLeg.rawValue][0],
                          y: keypoints3d[KeypointJointType.leftLeg.rawValue][1],
                          z: keypoints3d[KeypointJointType.leftLeg.rawValue][2]),
            HumanKeypoint(type: KeypointJointType.leftFoot.rawValue,
                          x: keypoints3d[KeypointJointType.leftFoot.rawValue][0],
                          y: keypoints3d[KeypointJointType.leftFoot.rawValue][1],
                          z: keypoints3d[KeypointJointType.leftFoot.rawValue][2])
        ]
    }
    
    /// Get a certain keypoint object based on the desired type
    /// - Parameter type: The type of the keypoint
    /// - Returns: Returns the desired keypoint object. Will return `nil` if the keypoint doesn't exist
    func getKeypoint(type: KeypointJointType) -> HumanKeypoint? {
        keypoints.first(where: { $0.type == type })
    }
}
