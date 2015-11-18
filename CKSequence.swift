//
//  CKSequence.swift
//  CutsceneKit
//
//  Created by Ryan Campbell on 11/18/15.
//  Copyright © 2015 Phalanx Studios. All rights reserved.
//

import SpriteKit

/**
    A collection of CKAction objects that can be run together. For example, imagine two different nodes that you want to move at the same time. More importantly, you want them to be skippable actions. This class will manage the two independent actions as a group to make sure they work in coordination with one another.
*/
public class CKSequence {
    
    /// Store the actions that belong to this sequence.
    private var actions = [CKAction]()
    
    // MARK: Initilizing a CKSequence
    
    public init(actions:[CKAction]) {
        self.actions += actions
    }
    
    // MARK: Adding actions
    
    public func addActions(actions:[CKAction]) {
        self.actions += actions
    }
    
    // MARK: Processing the CKSequence
    
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
    
    internal func skip() {
        for container in self.actions {
            container.finish()
        }
    }
    
    // MARK: Utility
    
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
