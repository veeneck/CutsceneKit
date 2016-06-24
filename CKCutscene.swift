//
//  CSSequence.swift
//  CutsceneKit
//
//  Created by Ryan Campbell on 11/17/15.
//  Copyright © 2015 Phalanx Studios. All rights reserved.
//

import SpriteKit

/**
    Handles cleanup, management and playback of a collection of CKSequence objects that make up a cutscene.
 
    - warning: Because this class deals with closures and callbacks, you must keep the instance of it in scope / reference while it is running.
*/
public class CKCutscene {
    
    /// Collection of CKSequence objects to run.
    private var sequences = [CKSequence]()
    
    /// The current action that is executing.
    private var currentSequence : CKSequence?


    // MARK: Initializing a CKCutscene
    
    /** 
    Empty initializer to retain object for future use.
    
    - warning: Without any sequences, CKCutscene has no functionality.
    */
    public init() {

    }
    
    /**
    Initialize with sequences pre assigned.

     - parameter sequences: Default sequences to start with.
    */
    public init(sequences:[CKSequence]) {
        self.sequences += sequences
    }
    
    // MARK: Adding Sequences
    
    /**
    Append a group of sequences onto the end of the current sequence queue.
    
    - parameter sequences: CKSequence objects to append.
    */
    public func addSequences(sequences:[CKSequence]) {
        self.sequences += sequences
    }

    // MARK: Starting the Cutscene
    
    /** 
    Begin playing through each CKSequence until completion. Once a CKSequence has been completed,
    it will be permanently removed from the CKCutscene.
    
    - parameter completion: Callback to execute once all sequences have been completed.
    
    - note: There is no way to pause or stop playback. You can control this by only adding CKSequences that you wish to execute now, and delay adding others.
    */
    public func begin(completion:()->()) {
        self.playNextAction(completion: completion)
    }
    
    /// Internal method that `begin()` wraps around. Called recursively.
    private func playNextAction(completion:()->()) {
        if self.sequences.count > 0 {
            let next = self.sequences[0]
            self.currentSequence = next
            self.currentSequence?.run(callback: { [weak self] in
                self?.prepForNextSequence(completion: completion)
            })
        }
        else {
            completion()
        }
    }
    
    /// When a sequence has been completed, this will be called internally to cleanup and remove the sequence. The next CKSequence will be played automatically.
    private func prepForNextSequence(completion:()->()) {
        self.currentSequence = nil
        if self.sequences.count > 0 {
            self.sequences.remove(at: 0)
            self.playNextAction(completion: completion)
        }
    }
    
    // MARK: Skipping an Action
    
    /// Force the current running CKSequence to skip, and automatically start playing the next CKSequence if applicable.
    public func skipCurrentSequence() {
        self.currentSequence?.skip()
    }
    
}
