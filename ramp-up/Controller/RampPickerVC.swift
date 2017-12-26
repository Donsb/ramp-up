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
    
    // Initializer
    
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
        
        // Make the ramps rotate.
        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.01 * Double.pi), z: 0, duration: 0.1))
        
        // Add pipe to the pop up to choose from.
        var obj = SCNScene(named: "art.scnassets/pipe.dae")
        var node = obj?.rootNode.childNode(withName: "pipe", recursively: true)!
        node?.runAction(rotate)
        
            // Make the ramp smaller.
        node?.scale = SCNVector3Make(0.0022, 0.0022, 0.0022)
        node?.position = SCNVector3Make(-1, 0.7, -1)
        
        scene.rootNode.addChildNode(node!)
        
        // Add pyramid.
            /* NOTE:
                We can reuse obj and node as when we place the pip in the node scene it won't go away.
            */
        obj = SCNScene(named: "art.scnassets/pyramid.dae")
        node = obj?.rootNode.childNode(withName: "pyramid", recursively: true)!
        node?.runAction(rotate)
        node?.scale = SCNVector3Make(0.0058, 0.0058, 0.0058)
        node?.position = SCNVector3Make(-1, -0.45, -1)
        scene.rootNode.addChildNode(node!)
        
        // Add Quarter.
        obj = SCNScene(named: "art.scnassets/quarter.dae")
        node = obj?.rootNode.childNode(withName: "quarter", recursively: true)
        node?.runAction(rotate)
        node?.scale = SCNVector3Make(0.0058, 0.0058, 0.0058)
        node?.position = SCNVector3Make(-1, -2.2, -1)
        scene.rootNode.addChildNode(node!)
        
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
        }
        
    } // END Handle Tap.
    
    
} // END Class.























