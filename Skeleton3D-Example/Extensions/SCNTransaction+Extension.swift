//
//  SCNTransaction+Extension.swift
//  Skeleton3D-Example
//
//  Created by cleanmac on 22/05/23.
//

import SceneKit

extension SCNTransaction {
    
    /// Perform an animation with ease-in-out type
    /// - Parameters:
    ///   - duration: The duration of the animation
    ///   - transation: A closure containing animations to be performed
    static func animateEaseInOut(duration: TimeInterval, _ transaction: () -> ()) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transaction()
        SCNTransaction.commit()
    }
}
