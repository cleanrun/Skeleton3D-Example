//
//  SkeletonType.swift
//  Skeleton3D-Example
//
//  Created by cleanmac on 16/05/23.
//

import Foundation

enum SkeletonType: CaseIterable {
    case headToNose
    case noseToNeck
    case neckToRightArm
    case neckToLeftArm
    
    case rightArmToRightForearm
    case rightForearmToRightHand
    case leftArmToLeftForearm
    case leftForearmToLeftHand
    
    case neckToSpine
    case spineToHips
    case hipsToRightUpleg
    case hipsToLeftUpleg
    
    case rightUplegToRightLeg
    case rightLegToRightFoot
    case leftUplegToLeftLeg
    case leftLegToLeftFoot
    
    var originKeypoint: KeypointJointType {
        switch self {
        case .headToNose:
            return .head
        case .noseToNeck:
            return .nose
        case .neckToRightArm, .neckToLeftArm, .neckToSpine:
            return .neck1
        case .rightArmToRightForearm:
            return .rightArm
        case .rightForearmToRightHand:
            return .rightForearm
        case .leftArmToLeftForearm:
            return .leftArm
        case .leftForearmToLeftHand:
            return .leftForearm
        case .spineToHips:
            return .spine5
        case .hipsToRightUpleg, .hipsToLeftUpleg:
            return .hips
        case .rightUplegToRightLeg:
            return .rightUpleg
        case .rightLegToRightFoot:
            return .rightLeg
        case .leftUplegToLeftLeg:
            return .leftUpleg
        case .leftLegToLeftFoot:
            return .leftLeg
        }
    }
    
    var destinationKeypoint: KeypointJointType {
        switch self {
        case .headToNose:
            return .nose
        case .noseToNeck:
            return .neck1
        case .neckToRightArm:
            return .rightArm
        case .neckToLeftArm:
            return .leftArm
        case .rightArmToRightForearm:
            return .rightForearm
        case .rightForearmToRightHand:
            return .rightHand
        case .leftArmToLeftForearm:
            return .leftForearm
        case .leftForearmToLeftHand:
            return .leftHand
        case .neckToSpine:
            return .spine5
        case .spineToHips:
            return .hips
        case .hipsToRightUpleg:
            return .rightUpleg
        case .hipsToLeftUpleg:
            return .leftUpleg
        case .rightUplegToRightLeg:
            return .rightLeg
        case .rightLegToRightFoot:
            return .rightFoot
        case .leftUplegToLeftLeg:
            return .leftLeg
        case .leftLegToLeftFoot:
            return .leftFoot
        }
    }
}
