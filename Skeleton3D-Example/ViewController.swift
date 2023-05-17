//
//  ViewController.swift
//  Skeleton3D-Example
//
//  Created by cleanmac on 15/05/23.
//

import UIKit

class ViewController: UIViewController {
    
    /// A custom `SCNView`object to render the keypoints
    private var sceneView: Pose3DSceneView!
    
    /// The keypoints data loaded from a JSON file
    private var keypointsData: [KeypointsData]!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadJSONData()
        setSceneView()
    }
    
    /// Add the scene view into the controller and load the data to the scene view
    private func setSceneView() {
        sceneView = Pose3DSceneView(using: keypointsData)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sceneView)
        
        NSLayoutConstraint.activate([
            sceneView.leftAnchor.constraint(equalTo: view.leftAnchor),
            sceneView.rightAnchor.constraint(equalTo: view.rightAnchor),
            sceneView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    /// Load the data from a JSON file from the Bundle
    private func loadJSONData() {
        guard let url = Bundle.main.url(forResource: "keypoints_data", withExtension: "json") else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let keypoints = try decoder.decode([KeypointsData].self, from: data)
            keypointsData = keypoints
        } catch {
            print(error.localizedDescription)
        }
    }

}

