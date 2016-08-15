//
//  CKAction.swift
//  CutsceneKit
//
//  Created by Ryan Campbell on 11/17/15.
//  Copyright © 2015 Phalanx Studios. All rights reserved.
//

import SpriteKit

/**
    A container for SKActions and the nodes they should run on. Also manages the timing function that allows SKActions to be skipped. To use a CKAction, it must be added to a CKSequence, which is then controlled by a CKCutscene.
 
    - note: From a technical perspective, this imlementation is required because a bool must be set as a member variable of the SKAction. The `timingFunc` uses that state to determine when to skip an action.
 
    - precondition: If you are adding a child to `node` with a `runBlock`, you can name the child "CKActionObject" and it will automatically be removed when the action has finished.
*/
public class CKAction {
    
    /// Internal state of the action
    private var finishEarly : Bool = false
    
    /// Node that should run the action
    internal var node : SKNode
    
    /// The SKAction to run
    internal var action : SKAction
    
    /// Desired timing function
    private var desiredTiming : SKActionTimingFunction?
    
    /** 
    Initilize an CKAction and override the timing function to allow skip functionality.

    - parameter node: The node to run the action on.
    - parameter action: The SKAction to run.
    - parameter desiredTiming: `SKActionTimingFunction` to assign to the `action`. This is the only way to control playback speed.
    */
    public init(node:SKNode, action:SKAction, desiredTiming:SKActionTimingFunction? = nil) {
        self.node = node
        self.action = action
        self.action.speed = 1
        self.desiredTiming = desiredTiming
        self.action.timingFunction = self.timingFunc
    }
    
    /// Trigger runAction on the SKAction.
    internal func process(callback:@escaping ()->()) {
        self.node.run(action) {
            self.cleanup()
            callback()
        }
    }
    
    /// Will remove nodes from parent with the name of "CKActionObject".
    /// - note: This is utility for `SKAction.runBlock` where a node is added that should be removed at the end of the sequence. Because this use case is so common, it seemed appropriate to make part of the core.
    internal func cleanup() {
        self.node.childNode(withName: "CKActionObject")?.removeFromParent()
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
