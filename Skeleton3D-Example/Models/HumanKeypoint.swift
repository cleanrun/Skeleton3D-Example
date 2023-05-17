//
//  HumanKeypoint.swift
//  Skeleton3D-Example
//
//  Created by cleanmac on 15/05/23.
//

import Foundation
import SceneKit

struct HumanKeypoint {
    let type: KeypointJointType
    let x: Float
    let y: Float
    let z: Float
    
    init(type: Int, x: Float, y: Float, z: Float) {
        self.type = KeypointJointType(rawValue: type) ?? .unknown
        self.x = x
        self.y = y
        self.z = z
    }
    
    /// The `SCNVector3` object based on the coordinates
    var position: SCNVector3 { SCNVector3Make(x, y, z) }
    
    /// Convert the original position relative to the scene's size
    /// - Parameter size: The size of the scene
    /// - Returns: Returns a new position relative to the scene's size
    func getConvertedPosition(relativeTo size: CGFloat) -> SCNVector3 {
        SCNVector3(CGFloat(position.x)*size - size/2, (1.0 - CGFloat(position.y))*size - size/2, (1.0 - CGFloat(position.z))*size - size/2)
    }
    
}
