//
//  CKSequence.swift
//  CutsceneKit
//
//  Created by Ryan Campbell on 11/17/15.
//  Copyright © 2015 Phalanx Studios. All rights reserved.
//

import SpriteKit

public class CKSequence {
    
    var actions = [CKAction]()
    
    var actionIndex : Int = 0
    
    var callbackIndex : Int = 0
        
    var running : Bool = true
    
    let targetNode : SKNode
    
    public init(targetNode:SKNode) {
        self.targetNode = targetNode
    }
    
    func run(callback:()->()) {
        if(self.running == true) {
            
            var activeCallback : ()->() = {}
            if(self.actionIndex == self.callbackIndex) {
                activeCallback = callback
            }
            
            if self.actions.count > self.actionIndex {
                
                let nextAction = self.actions[actionIndex]
                self.targetNode.addChild(nextAction)
                nextAction.process(activeCallback)
                self.actionIndex += 1
                
                if self.actions.count >= self.actionIndex {
                    self.delay(nextAction.delay, closure: {
                        self.run(callback)
                    })
                }
                
            }
        }
    }
    
    func skip() {
        self.running = false
        for action in self.actions {
            action.finish()
        }
    }
    
    func finish() {
        for action in self.actions {
            action.removeFromParent()
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
}
