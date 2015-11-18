//
//  CKAction.swift
//  CutsceneKit
//
//  Created by Ryan Campbell on 11/17/15.
//  Copyright © 2015 Phalanx Studios. All rights reserved.
//

import SpriteKit

/**
    Sublcass of SKAction that allows an action to be skipped to the end.
 
    - note: From a technical perspective, this imlementation is required because a bool must be set as a member variable of the SKAction. The `timingFunc` uses that state to determine when to skip an action.
*/
public class CKAction {
    
    /// Internal state of the action
    private var finishEarly : Bool = false
    
    /// Node that should run the action
    private var node : SKNode
    
    /// The SKAction to run
    internal var action : SKAction
    
    /// Desired timing function
    private var desiredTiming : SKActionTimingFunction?
    
    /// Initilize an SKAction and override the timing function to allow skip functionality.
    public init(node:SKNode, action:SKAction, desiredTiming:SKActionTimingFunction? = nil) {
        self.node = node
        self.action = action
        self.action.speed = 1
        self.desiredTiming = desiredTiming
        self.action.timingFunction = self.timingFunc
    }
    
    internal func process(callback:()->()) {
        self.node.runAction(action) {
            callback()
        }
    }
    
    /// Skip to the end of the action.
    internal func finish() {
        self.finishEarly = true
    }
    
    /// Timing function to set on the action which will return normal time unless finish early is set to true.
    private func timingFunc(time:Float) -> Float {
        if(self.finishEarly) {
            return 1.0
        }
        else {
            if let desired = self.desiredTiming {
                return desired(time)
            }
            else {
                return time
            }
        }
    }
    
}