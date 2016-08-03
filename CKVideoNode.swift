//
//  CKVideoNode.swift
//  CutsceneKit
//
//  Created by Ryan Campbell on 11/18/15.
//  Copyright © 2015 Phalanx Studios. All rights reserved.
//

import SpriteKit
import AVFoundation

/**
    A sublcass of SKVideoNode that adds useful extensions such as timed hooks, callback on completetion, and cleanup afterwards. Also makes it easier to create a video based off of an AVPlayer.
 
    - note: Currently, there is no tie in to the rest of CutsceneKit. Brainstorming ways to add a CKCutscene combined with movie timing. An example would be dialogue / translations on top of the movie.
*/
public class CKVideoNode : SKVideoNode {
    
    /// Callback to use when video has completed.
    private var callback : ()->() = {}
    
    /// Handle on the player so that we can add hooks after initialization.
    public let player : AVPlayer
    
    /// Handle of the playerItem so that we can add notifications after initialization.
    public let playerItem : AVPlayerItem
    
    // MARK: Initializing a CKVideoNode
    
    /**
    Create a CKVideoNode using an AVPlayer.
    
    - parameter name: The name of the movie without the file extension.
    - parameter ext: The file extension. I.e.: "mov"
    */
    public init(name:String, ext:String) {
        let av =  CKVideoNode.createAVVideoPlayer(name: name, ext: ext)
        self.player = av.player
        self.playerItem = av.item
        super.init(avPlayer:self.player)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Timing Hooks
    
    /// Run a block of code at the provided timestamp.
    public func addTimingHook(timestamp:Double, block:()->()) {
        let cmTime  = CMTimeMake(Int64(timestamp), 1)
        let cmValue = NSValue(time:cmTime)
        self.player.addBoundaryTimeObserver(forTimes: [cmValue], queue: nil, using: block)
    }
    

    // MARK: Ending a Video
    
    /**
    Removes any notification center listeners on the node, and then adds a new listener for `AVPlayerItemDidPlayToEndTimeNotification`.
    
    - parameter callback: A function to be called when the player finishes playing.
    */
    public func registerCompletionCallback(callback:()->()) {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.playerDidFinishPlaying),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: self.playerItem)
        self.callback = callback
    }
    
    /// Utility to function to jump the player to the end of the video. Preferred way to "skip" a video as it will route through appopriate cleanup functions.
    public func skipToEnd() {
        self.playerDidFinishPlaying(note: nil)
    }
    
    /// Private function to handle cleanup of player and process callback
    public func playerDidFinishPlaying(note: NSNotification?) {
        NotificationCenter.default.removeObserver(self)
        self.callback()
    }
    
    // MARK: Factory Methods
    
    /// Create an AVPlayer given a file name. Example parameters are "MovieName" and "mov".
    /// - returns: Both the player and playerItem to give full control. For example, playerItem is used for NotificationCenter while player can control playback.
    private class func createAVVideoPlayer(name:String, ext:String) -> (player:AVPlayer, item:AVPlayerItem) {
        let url = Bundle.main.url(forResource: "\(name)", withExtension: ext)
        let playerItem = AVPlayerItem(url: url!)
        let player=AVPlayer(playerItem: playerItem)
        return (player, playerItem)
    }

    
}
