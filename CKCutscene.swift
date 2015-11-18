//
//  CSSequence.swift
//  CutsceneKit
//
//  Created by Ryan Campbell on 11/17/15.
//  Copyright © 2015 Phalanx Studios. All rights reserved.
//

import SpriteKit

/**
    A collection of CKSequence objects that make up a scene.
*/
public class CKCutscene {
    
    /// Collection of CKSequence objects to run.
    private var sequences = [CKSequence]()
    
    /// The current sequence that is executing.
    private var currentSequence : CKSequence?
    
    // MARK: Initializing a CKCutscene
    
    /// Empty initializer to retain object for future use.
    /// - note: Without any sequences, CKCutscene has no functionality.
    public init() {
        
    }
    
    /// Initialze with sequences pre assigned.
    public init(sequences:[CKSequence]) {
        self.sequences += sequences
    }

    // MARK: Starting the Cutscene
    
    /// Begin playing through each CKSequence until completion. Once a CKSequence has been completed, 
    /// it will be premanently removed from the CKCutscene.
    /// - parameter completion: Callback to execute once all sequences have been completed.
    /// - note: There is no way to pause or stop playback. You can control this by only adding CKSequences that you wish to execute now, and delay adding others.
    public func playNextSequence(completion:()->()) {
        if self.sequences.count > 0 {
            let next = self.sequences[0] as CKSequence
            self.currentSequence = next
            self.currentSequence?.run({ [weak self] in
                if let this = self {
                    this.prepForNextSequence(completion)
                }
            })
        }
        else {
            completion()
        }
    }
    
    /// When a sequence has been completed, this will be called internally to cleanup and remove the sequence. The next CKSequence will be played automatically.
    private func prepForNextSequence(completion:()->()) {
        self.currentSequence?.finish()
        self.currentSequence = nil
        if self.sequences.count > 0 {
            self.sequences.removeAtIndex(0)
            self.playNextSequence(completion)
        }
    }
    
    // MARK: Skipping a Sequence
    
    /// Force the current running sequence to skip, and automatically start playing the next sequence if applicable.
    func skipCurrentSequence() {
        self.currentSequence?.skip()
    }

    
}
