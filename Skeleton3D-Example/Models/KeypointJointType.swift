//
//  KeypointJointType.swift
//  Skeleton3D-Example
//
//  Created by cleanmac on 15/05/23.
//

import UIKit

enum KeypointJointType: Int, CaseIterable {
    case hips          = 0
    
    case leftUpleg     = 1
    case leftLeg       = 2
    case leftFoot      = 3
    case rightUpleg    = 4
    case rightLeg      = 5
    case rightFoot     = 6
    
    case spine5        = 7
    case neck1         = 8
    case nose          = 9
    case head          = 10
    
    case rightArm      = 11
    case rightForearm  = 12
    case rightHand     = 13
    case leftArm       = 14
    case leftForearm   = 15
    case leftHand      = 16
    
    case unknown       = 99
    
    // FIXME: This is just a placeholder Color to differentiate which type of the keypoint.
    var color: UIColor {
        switch self {
        case .head:
            return UIColor.blue
        case .rightArm:
            return UIColor.red
        case .leftArm:
            return UIColor.green
        case .hips:
            return UIColor.black
        case .leftLeg:
            return UIColor.brown
        case .rightLeg:
            return UIColor.yellow
        default:
            return UIColor.gray
        }
    }
}
