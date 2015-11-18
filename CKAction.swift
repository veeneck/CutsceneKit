//
//  CKAction.swift
//  CutsceneKit
//
//  Created by Ryan Campbell on 11/17/15.
//  Copyright © 2015 Phalanx Studios. All rights reserved.
//

import SpriteKit

/**
    An individual action to run as part of a CKSequence.
*/
public class CKAction : SKNode {
    
    var delay : Double = 0
    
    var finishEarly : Bool = false
    
    public override init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Running an Action
    
    func process(callback:()->()) {
        // override this
    }
    
    func finish() {
        self.finishEarly = true
    }
    
    func timingFunc(time:Float) -> Float {
        if(self.finishEarly) {
            return 1.0
        }
        else {
            return time
        }
    }
    
    func setTimingFunctionsForActions(actions:Array<SKAction>) -> Array<SKAction> {
        for action in actions {
            action.timingFunction = self.timingFunc
        }
        return actions
    }
        
    
}