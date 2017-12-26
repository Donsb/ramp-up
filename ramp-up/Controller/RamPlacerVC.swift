//
//  RampPlacerVC.swift
//  ramp-up
//
//  Created by Donald Belliveau on 2017-12-26.
//  Copyright © 2017 Donald Belliveau. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class RampPlacerVC: UIViewController, ARSCNViewDelegate, UIPopoverPresentationControllerDelegate {
    
    // Instance Variables
    
    var selectedRamp: String?
    
    // IBOutlets

    @IBOutlet var sceneView: ARSCNView!
    
    // Functions
    
    
    // View Did Load.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/quarter.dae")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
    } // END View Did Load.
    
    
    // View Will Appear.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    } // END View Will Appear.
    
    
    // View Will Dissapear.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    } // END View Will Dissapear.
    
    
    // Did Receive Memory Warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    } // END Did Receive Memory Warning.
    

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    
    // Session - Did Fail With Warning.
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    } // END Session - Did Fail With Warning.
    
    
    // Session - Sessions Was Interupted.
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    } // END Session - Sessions Was Interupted.
    
    
    // Session - Session Interruption Ended.
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    } // END Session - Session Interruption Ended.
    
    
    // Adaptive Presentation Style for Controller.
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        /* This function is needed to return .none so it doesn't try to make your pop up full screen. */
        return .none
        
    } // END Adaptive Presentation Style for Controller.
    
    
    // Touches Began.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        // featurePoint finds the features in your scene (wall, chair,...)
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [.featurePoint])
        guard let hitFeature = results.last else { return }
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        
        placeRamp(position: hitPosition)
    } // END Touches Began.
    
    
    // On Ramp Button Pressed.
    @IBAction func onRampBtnPressed(_ sender: UIButton) {
        
        /* Create the Pop Up on the side where the button is. */
        let rampPickerVC = RampPickerVC(size: CGSize(width: 250, height: 500))
        rampPickerVC.rampPlacerVC = self
        rampPickerVC.modalPresentationStyle = .popover
        rampPickerVC.popoverPresentationController?.delegate = self
        present(rampPickerVC, animated: true, completion: nil)
        rampPickerVC.popoverPresentationController?.sourceView = sender
        rampPickerVC.popoverPresentationController?.sourceRect = sender.bounds
        
    } // END On Ramp Button Pressed.
    
    
    // On Ramp Selected.
    func onRampSelected(_ rampName: String) {
        selectedRamp = rampName
    } // On Ramp Selected.
    
    
    // Place Ramp.
    func placeRamp(position: SCNVector3) {
        
    } // Place Ramp.
    
    
} // END Class.






















