//
//  CKSequence.swift
//  CutsceneKit
//
//  Created by Ryan Campbell on 11/18/15.
//  Copyright © 2015 Phalanx Studios. All rights reserved.
//

import SpriteKit

/**
    A collection of CKAction objects that can be run together. Typically, you would run SKAction calls independtly from one another. For example, if you wanted to move two different nodes then you would do this:
 
        nodeA.runAction(SKAction.moveToX(500, duration:5)
        nodeB.runAction(SKAction.moveToX(500, duration:5)
 
    The downside to this is that the actions have no link to one another. If one finishes, the other doesn't care. A CKSequence is a collection of SKActions (wrapped as [CKAction]). By keeping track of the collection, we can run the different actions on different nodes at the same time. This allows for advanced functionality such as skipping / fast-forwarding a sequence of actions together. The code above would become:
 
        let sequence = CKSequence(actions: [
            CKAction(node: nodeA, action: SKAction.moveToX(500, duration: 5)),
            CKAction(node: nodeB, action: SKAction.moveToX(500, duration: 5))
        ])
 
    Given a sequence, playback can be controlled with a CKCutscene.
 
*/
public class CKSequence {
    
    /// Store the actions that belong to this sequence.
    private var actions = [CKAction]()
    
    // MARK: Initilizing a CKSequence
    
    /**
        Initialize with CKAction objects. A CKSequence without actions will not do anything.
    */
    public init(actions:[CKAction]) {
        self.actions += actions
    }
    
    // MARK: Adding actions
    
    /// Append actions onto the existing group.
    public func addActions(actions:[CKAction]) {
        self.actions += actions
    }
    
    // MARK: Processing the CKSequence
    
    /**
    This will cause each action in the sequence to be run.

    - returns: The `callback` will be triggered when the action with the longest duration completes.
    */
    internal func run(callback:()->()) {
        
        /// Determine longest duration as that is when the final callback should be triggered.
        /// Active callback will be empty except for that one CKAction
        let containerWithLongestDuration = self.determineLongestAction()
        var activeCallback : ()->()
        
        /// Loop over each action and run it. Only assign true callback to action with longest duration.
        for (index, container) in self.actions.enumerate() {
            if index == containerWithLongestDuration {
                activeCallback = callback
            }
            else {
                activeCallback = {}
            }
            
            container.process(activeCallback)
        }
    }
    
    // MARK: Skipping a Sequence
    
    /// Call skip on each action.
    internal func skip() {
        for container in self.actions {
            container.finish()
        }
    }
    
    // MARK: Utility
    
    /// Return the action with the longest duration.
    private func determineLongestAction() -> Int {
        var ret : Int = 0
        for (index, container) in self.actions.enumerate() {
            if container.action.duration > self.actions[ret].action.duration {
                ret = index
            }
        }
        return ret
    }
    
}
