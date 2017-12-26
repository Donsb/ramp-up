//
//  RampPickerVC.swift
//  ramp-up
//
//  Created by Donald Belliveau on 2017-12-26.
//  Copyright © 2017 Donald Belliveau. All rights reserved.
//

import UIKit
import SceneKit

class RampPickerVC: UIViewController {
    
    // Instance Variables
    
    var sceneView: SCNView!
    var size: CGSize!
    weak var rampPlacerVC: RampPlacerVC!
    
    // Initializers
    
    // init.
    init(size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.size = size
    } // init.
    
    
    // Required Init.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } // Required Init.
    
    
    // Functions
    
    // View Did Load.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = CGRect(origin: CGPoint.zero, size: size)
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.insertSubview(sceneView, at: 0)
        
        preferredContentSize = size
        
        // Add Border to the pop up.
        view.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.borderWidth = 3.0
        
        // Make the popup background black.
        let scene = SCNScene(named: "art.scnassets/ramps.scn")!
        sceneView.scene = scene
        
        // Change camera of the popup to render a 2D image.
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene.rootNode.camera = camera
        
        // Add Tap Recognizer.
        let tap = UITapGestureRecognizer(target: self, action: #selector (handleTap(_:)))
        sceneView.addGestureRecognizer(tap)
        
        // Add Pipe to Pop Up.
        let pipe = Ramp.getPipe()
        Ramp.startRotation(node: pipe)
        scene.rootNode.addChildNode(pipe)
        
        // Add Pyramid to Pop Up.
        let pyramid = Ramp.getPyramid()
        Ramp.startRotation(node: pyramid)
        scene.rootNode.addChildNode(pyramid)
        
        // Add Quarter to Pop Up.
        let quarter = Ramp.getQuarter()
        Ramp.startRotation(node: quarter)
        scene.rootNode.addChildNode(quarter)
        
    } // END View Did Load.
    
    
    // Did Receive Memory Warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } // END Did Receive Memory Warning.
    
    
    // Handle Tap.
    @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        
        let p = gestureRecognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(p, options: [:])
        
        if hitResults.count > 0 {
            let node = hitResults[0].node
            rampPlacerVC.onRampSelected(node.name!)
            dismiss(animated: true, completion: nil)
        }
        
    } // END Handle Tap.
    
    
} // END Class.


