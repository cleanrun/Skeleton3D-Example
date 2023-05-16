//
//  Pose3DSceneView.swift
//  Skeleton3D-Example
//
//  Created by cleanmac on 15/05/23.
//

import SceneKit
import QuartzCore

final class Pose3DSceneView: SCNView {
    
    /// The current scene of this view
    private var currentScene: SCNScene!
    
    /// The camera node for this scene view
    private var cameraNode: SCNNode!
    
    /// The light node, this uses the type `omni`
    private var lightNode: SCNNode!
    
    /// Another light node that uses the type `ambient`
    private var ambientLightNode: SCNNode!
    
    private let studioSize: Float = 10
    private let studioDepth: Float = 0.5
    private let lineRadius: Float = 0.05
    private let keypointNodeRadius: CGFloat = 0.15
    
    private var isAdjustMode = false
    
    /// Every keypoints of the data, this will be used as an indicator for initializing the nodes
    private var keypoints: [HumanKeypoint] = []
    
    /// The keypoint nodes based on the data provided
    private var keypointNodes: [SCNNode] = []
    
    /// Sets up the view
    func setup() {
        currentScene = SCNScene()
        
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        currentScene.rootNode.addChildNode(cameraNode)
        
        cameraNode.position = SCNVector3Make(0, 0, 40)
        
        lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3Make(0, 13, 9)
        currentScene.rootNode.addChildNode(lightNode)
        
        ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        currentScene.rootNode.addChildNode(ambientLightNode)
        
        
        scene = currentScene
        
        allowsCameraControl = true
        showsStatistics = true
        backgroundColor = .lightGray
        autoenablesDefaultLighting = true
    }
    
    /// Initialize the background nodes for containing the keypoints and skeletons
    func setBackgroundNodes() {
        guard let scene else { return }
        
        let extendedStudioSize = studioSize * 1.2
        
        let boxGeometry = SCNBox(width: CGFloat(extendedStudioSize),
                                 height: CGFloat(extendedStudioSize),
                                 length: CGFloat(studioDepth),
                                 chamferRadius: 0)
        let boxNode = SCNNode(geometry: boxGeometry)
        boxNode.position = SCNVector3Make(0, -extendedStudioSize/2, 0)
        scene.rootNode.addChildNode(boxNode)
        
        let floorGeometry = SCNBox(width: CGFloat(extendedStudioSize),
                                   height: CGFloat(studioDepth),
                                   length: CGFloat(extendedStudioSize),
                                   chamferRadius: 0)
        let floorNode = SCNNode(geometry: floorGeometry)
        floorNode.position = SCNVector3Make(0, -extendedStudioSize/2, 0)
        scene.rootNode.addChildNode(floorNode)
    }
    
    /// Create the skeleton nodes between provided keypoints
    /// - Parameter type: The type of the skeleton to retrieve the origin and destination vectors
    /// - Returns: Returns the created nodes between both keypoint vectors. Returns `nil` if one of the keypoints doesn't exist
    private func createLineBetweenNodes(type: SkeletonType) -> SCNNode? {
        guard
            let originKeypointVector = keypoints.first(where: { $0.type == type.originKeypoint })?.getConvertedPosition(relativeTo: CGFloat(studioSize)),
            let destinationKeypointVector = keypoints.first(where: { $0.type == type.destinationKeypoint })?.getConvertedPosition(relativeTo: CGFloat(studioSize))
        else { return nil }
        
        let vector = SCNVector3Make(originKeypointVector.x - destinationKeypointVector.x,
                                    originKeypointVector.y - destinationKeypointVector.y,
                                    originKeypointVector.z - destinationKeypointVector.z)
        let distance = sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
        let midPosition = SCNVector3Make((originKeypointVector.x + destinationKeypointVector.x) / 2,
                                         (originKeypointVector.y + destinationKeypointVector.y) / 2,
                                         (originKeypointVector.z + destinationKeypointVector.z) / 2)
        
        let line = SCNCylinder()
        line.radius = CGFloat(lineRadius)
        line.height = CGFloat(distance)
        line.radialSegmentCount = 5
        
        let lineNode = SCNNode(geometry: line)
        lineNode.position = midPosition
        lineNode.look(at: destinationKeypointVector,
                      up: scene!.rootNode.worldUp,
                      localFront: lineNode.worldUp)
        
        return lineNode
    }
    
    /// Create a specific sphere node to indicate the position of keypoint from a data
    /// - Parameter keypoint: The keypoint model
    /// - Returns: Returns the created node
    private func createKeypointNode(from keypoint: HumanKeypoint) -> SCNNode {
        let sphere = SCNSphere(radius: keypointNodeRadius)
        let keypointNode = SCNNode(geometry: sphere)
        keypointNode.position = keypoint.getConvertedPosition(relativeTo: CGFloat(studioSize))
        keypointNode.geometry?.firstMaterial?.diffuse.contents = keypoint.type.color
        return keypointNode
    }
    
    /// Create nodes from a keypoint model and add it to the scene
    /// - Parameter model: The model used to add the keypoints
    func configureKeypoints(_ model: KeypointsData) {
        model.keypoints.forEach { keypoint in
            let keypoint = keypoint
            let keypointNode = createKeypointNode(from: keypoint)
            
            keypoints.append(keypoint)
            keypointNodes.append(keypointNode)
            
            scene?.rootNode.addChildNode(keypointNode)
        }
    }
    
}
