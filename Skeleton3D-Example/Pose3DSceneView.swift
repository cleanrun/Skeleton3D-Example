//
//  Pose3DSceneView.swift
//  Skeleton3D-Example
//
//  Created by cleanmac on 15/05/23.
//

import SceneKit

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
    
    /// Pretty much the Z coordinate of the camera node
    private let cameraDistance: Float = 20
    
    private var isAdjustMode = false
    
    /// The keypoints data loaded from a JSON file
    private var keypointsData: [KeypointsData]!
    
    /// Every keypoints of the data, this will be used as an indicator for initializing the nodes
    private var keypoints: [HumanKeypoint] = []
    
    /// The keypoint nodes based on the data provided
    private var keypointNodes: [SCNNode] = []
    
    /// The skeleton nodes that connects 2 keypoint nodes
    private var skeletonNodes: [SCNNode] = []
    
    required init(using keypointsData: [KeypointsData]) {
        self.keypointsData = keypointsData
        super.init(frame: .zero, options: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard/XIB initializations are not supported")
    }
    
    /// Sets up the view
    private func commonInit() {
        currentScene = SCNScene()
        
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        currentScene.rootNode.addChildNode(cameraNode)
        
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
        
        // This is to limit the camera rotation only to X axis
        defaultCameraController.maximumVerticalAngle = 0.001
        
        configureKeypoints(keypointsData.first!)
        configureSkeletons()
        setCameraNodePosition()
    }
    
    /// Initialize the background nodes for containing the keypoints and skeletons
    private func setBackgroundNodes() {
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
    
    /// Setting up the camera node position relative to the hip x and y coordinates.
    ///
    /// The reason for this is to make the 3D model is centered to the screen.
    private func setCameraNodePosition() {
        guard let hipKeypoint = keypoints.first(where: { $0.type == .hips }) else { return }
        
        cameraNode.position = SCNVector3Make(hipKeypoint.getConvertedPosition(relativeTo: CGFloat(studioSize)).x,
                                             hipKeypoint.getConvertedPosition(relativeTo: CGFloat(studioSize)).y,
                                             cameraDistance)
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
    
    /// Create the skeleton nodes between provided keypoints
    ///
    /// This function must be called AFTER keypoint nodes is created. Otherwise this function return `nil`.
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
    
    /// Create nodes from a keypoint model and add it to the scene
    /// - Parameter model: The model used to add the keypoints
    private func configureKeypoints(_ model: KeypointsData) {
        model.keypoints.forEach { keypoint in
            let keypoint = keypoint
            let keypointNode = createKeypointNode(from: keypoint)
            
            keypoints.append(keypoint)
            keypointNodes.append(keypointNode)
            
            scene?.rootNode.addChildNode(keypointNode)
        }
    }
    
    /// Create skeleton nodes that connects between 2 keypoints based on a certain connection type
    private func configureSkeletons() {
        SkeletonType.allCases.forEach { type in
            guard
                let scene,
                let skeletonNode = createLineBetweenNodes(type: type)
            else { return }
            skeletonNodes.append(skeletonNode)
            scene.rootNode.addChildNode(skeletonNode)
        }
    }
    
}
