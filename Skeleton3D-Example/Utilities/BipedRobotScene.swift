//
//  BipedRobotScene.swift
//  Skeleton3D-Example
//
//  Created by cleanmac on 22/05/23.
//

import SceneKit

final class BipedRobotScene: SCNScene {
    
    convenience override init() {
        let url = Bundle.main.url(forResource: "biped_robot", withExtension: "usdz")!
        try! self.init(url: url)
    }
}
