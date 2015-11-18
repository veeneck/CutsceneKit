//
//  CSSequence.swift
//  CutsceneKit
//
//  Created by Ryan Campbell on 11/17/15.
//  Copyright © 2015 Phalanx Studios. All rights reserved.
//

import SpriteKit

/**
    Post commit
*/
public class CKCutscene {
    
    var sequences = [CKSequence]()
    
    var currentSequence : CKSequence?
    
    
    // MARK: Initializing a CKCutscene
    
    public init() {
        
    }
    
    // MARK: Starting the Sequences
    
    func playNextAction(completion:()->()) {
        if self.sequences.count > 0 {
            let next = self.sequences[0] as CKSequence
            self.currentSequence = next
            self.currentSequence?.run({ [weak self] in
                if let this = self {
                    this.prepForNextAction(completion)
                }
                })
        }
        else {
            completion()
        }
    }
    
    func prepForNextAction(completion:()->()) {
        self.currentSequence?.finish()
        self.currentSequence = nil
        if self.sequences.count > 0 {
            self.sequences.removeAtIndex(0)
            self.playNextAction(completion)
        }
        else {
            print("done")
        }
    }
    
    // MARK: Skipping a Sequence
    
    func skipCurrentSequence() {
        self.currentSequence?.skip()
    }

    
}
