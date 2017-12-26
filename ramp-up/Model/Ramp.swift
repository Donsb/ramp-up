//
//  Ramp.swift
//  ramp-up
//
//  Created by Donald Belliveau on 2017-12-26.
//  Copyright © 2017 Donald Belliveau. All rights reserved.
//

import Foundation
import SceneKit

class Ramp {
    
    // Class Functions
    
    // Get Pipe.
    class func getPipe()-> SCNNode {
        let obj = SCNScene(named: "art.scnassets/pipe.dae")
        let node = obj?.rootNode.childNode(withName: "pipe", recursively: true)!
        
        // Make the ramp smaller.
        node?.scale = SCNVector3Make(0.0022, 0.0022, 0.0022)
        node?.position = SCNVector3Make(-1, 0.7, -1)
        
        return node!
    } // END Get Pipe.
    
    
    // Get Pyramid.
    class func getPyramid()-> SCNNode {
        let obj = SCNScene(named: "art.scnassets/pyramid.dae")
        let node = obj?.rootNode.childNode(withName: "pyramid", recursively: true)!
        node?.scale = SCNVector3Make(0.0058, 0.0058, 0.0058)
        node?.position = SCNVector3Make(-1, -0.45, -1)
        return node!
    } // Get Pyramid.
    
    
    // Get Quarter.
    class func getQuarter()-> SCNNode {
        let obj = SCNScene(named: "art.scnassets/quarter.dae")
        let node = obj?.rootNode.childNode(withName: "quarter", recursively: true)
        node?.scale = SCNVector3Make(0.0058, 0.0058, 0.0058)
        node?.position = SCNVector3Make(-1, -2.2, -1)
        return node!
    } // END Get Quarter.
    
    
} // END Class.















