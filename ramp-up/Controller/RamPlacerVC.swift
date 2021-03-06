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
    
    var selectedRampName: String?
    var selectedRamp: SCNNode?
    
    // IBOutlets

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var controls: UIStackView!
    @IBOutlet weak var rotateBtn: UIButton!
    @IBOutlet weak var upBtn: UIButton!
    @IBOutlet weak var downBtn: UIButton!
    
    // Functions
    
    // View Did Load.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/main.scn")!
        sceneView.autoenablesDefaultLighting = true
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Gesture Recognizers for our Control Buttons.
        let gesture1 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture:)))
        let gesture2 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture:)))
        let gesture3 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture:)))
        gesture1.minimumPressDuration = 0.1
        gesture2.minimumPressDuration = 0.1
        gesture3.minimumPressDuration = 0.1
        rotateBtn.addGestureRecognizer(gesture1)
        upBtn.addGestureRecognizer(gesture2)
        downBtn.addGestureRecognizer(gesture3)
        
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
        selectedRampName = rampName
    } // On Ramp Selected.
    
    
    // Place Ramp.
    func placeRamp(position: SCNVector3) {
        if let rampName = selectedRampName {
            controls.isHidden = false
            let ramp = Ramp.getRampForName(rampName: rampName)
            selectedRamp = ramp
            ramp.position = position
            ramp.scale = SCNVector3Make(0.01, 0.01, 0.01)
            sceneView.scene.rootNode.addChildNode(ramp)
        }
    } // Place Ramp.
    
    
    // On Remove Pressed.
    @IBAction func onRemovePressed(_ sender: Any) {
        if let ramp = selectedRamp {
            ramp.removeFromParentNode()
            selectedRamp = nil
        }
    } // On Remove Pressed.
    
    
    // On Long Press.
    @objc func onLongPress(gesture: UILongPressGestureRecognizer) {
        
        if let ramp = selectedRamp {
            
            if gesture.state == .ended {
                
                ramp.removeAllActions()
                
            } else if gesture.state == .began {
                
                if gesture.view === rotateBtn {
                    /*
                     NOTE: == checks agains type and value.  === also checks reference location.
                     */
                    let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.08 * Double.pi), z: 0, duration: 0.1))
                    ramp.runAction(rotate)
                    
                } else if gesture.view === upBtn {
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0.08, z: 0, duration: 0.1))
                    ramp.runAction(move)
                    
                } else if gesture.view === downBtn {
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: -0.08, z: 0, duration: 0.1))
                    ramp.runAction(move)
                }
                
            }
            
        }
        
    } // END On Long Press.
    
    
} // END Class.


