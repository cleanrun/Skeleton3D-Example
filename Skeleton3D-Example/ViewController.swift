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
    
    /// A button to switch to the next frame
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        return button
    }()
    
    /// A button to switch to the previous frame
    private lazy var previousButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Prev", for: .normal)
        return button
    }()
    
    /// The keypoints data loaded from a JSON file
    private var keypointsData: [KeypointsData]!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadJSONData()
        setupViews()
    }
    
    /// Add all of the required views into this controller's view hierarchy
    private func setupViews() {
        sceneView = Pose3DSceneView(using: keypointsData)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sceneView)
        view.addSubview(nextButton)
        view.addSubview(previousButton)
        
        NSLayoutConstraint.activate([
            sceneView.leftAnchor.constraint(equalTo: view.leftAnchor),
            sceneView.rightAnchor.constraint(equalTo: view.rightAnchor),
            sceneView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            previousButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            previousButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
        ])
        
        nextButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
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
    
    @objc private func buttonAction(_ sender: UIButton) {
        sceneView.switchFrame(isNext: sender == nextButton)
    }

}

