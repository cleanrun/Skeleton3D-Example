//
//  ViewController.swift
//  Skeleton3D-Example
//
//  Created by cleanmac on 15/05/23.
//

import UIKit

final class ViewController: UIViewController {
    
    /// A custom `SCNView`object to render the keypoints
    private var sceneView: Pose3DSceneView!
    
    /// A label that will show the current index of the showed frame
    private lazy var currentFrameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    /// The slider to move the frames
    private lazy var frameSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
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
        view.addSubview(frameSlider)
        view.addSubview(sceneView)
        view.addSubview(currentFrameLabel)
        
        NSLayoutConstraint.activate([
            frameSlider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            frameSlider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            frameSlider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            frameSlider.heightAnchor.constraint(equalToConstant: 80),
            
            sceneView.leftAnchor.constraint(equalTo: view.leftAnchor),
            sceneView.rightAnchor.constraint(equalTo: view.rightAnchor),
            sceneView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: frameSlider.topAnchor),
            
            currentFrameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentFrameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
        ])
        
        frameSlider.minimumValue = 1
        frameSlider.maximumValue = Float(keypointsData.count)
        frameSlider.addTarget(self, action: #selector(sliderAction(_:)), for: .valueChanged)
    }
    
    /// Load the data from a JSON file from the Bundle
    private func loadJSONData() {
        guard let url = Bundle.main.url(forResource: "keypoints_data_dtl", withExtension: "json") else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let keypoints = try decoder.decode([KeypointsData].self, from: data)
            keypointsData = keypoints
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc private func sliderAction(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        sceneView.switchFrame(to: currentValue)
        currentFrameLabel.text = "Frame: \(currentValue)"
    }

}

