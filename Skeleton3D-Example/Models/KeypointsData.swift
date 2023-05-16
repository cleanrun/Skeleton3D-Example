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
    
    var keypoints: [HumanKeypoint] {
        keypoints3d.enumerated().map { index, element in
            HumanKeypoint(type: index, x: element[0], y: element[1], z: element[2])
        }
    }
}
