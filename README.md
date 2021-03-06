# CutsceneKit

CutsceneKit is a SpriteKit dependent framework with the goal of providing two core pieces of functionality.

- Provide an event sequence that can run any group of SKActions on different nodes and allow them to be skipped.
- Add timed hooks to SKVideoNodes that allows them to be skimmed, skipped, and have dialogue overlay.

## Getting Started with CKCutscene

The main goal of CKCutscene is to provide playback control of SKActions. Here is a basic example:

    self.cutscene = CKCutscene()
    let sequence = CKSequence(actions: [
        CKAction(node: nodeA, action: SKAction.moveToX(500, duration: 5)),
        CKAction(node: nodeB, action: SKAction.moveToX(500, duration: 3))
    ])
    self.cutscene.addSequences([sequence])
    self.cutscene.begin() {
        print("playback complete")
    }

The code above will move two unrelated nodes (`nodeA` and `nodeB`). Each will move at their own speed / duration, and the callback will be called when the action with the longest duration has finished. Think of it as `SKAction.group()` on different nodes. This first benefit is nice, but it's worth noting that there is a workaround using [`SKAction.runAction(_:onChildWithName:)`](https://developer.apple.com/library/prerelease/mac/documentation/SpriteKit/Reference/SKAction_Ref/index.html#//apple_ref/occ/clm/SKAction/runAction:onChildWithName:) along with a `waitForDuration`.

Fortunately, there are more benefits to this approach. Among them are:

- Allows for all actions to be skipped to the end. This does not cancel the action -- it actually finishes it instantly.
- Allows for flags like `skipable` and `autoplay` to be applied to groups of actions. This enables sequences that can be paused and controlled by user input.

To dive in, start by looking at [CKCutscene](http://veeneck.github.io/CutsceneKit/Classes/CKCutscene.html) and then you can begin constructing a [CKSequence](http://veeneck.github.io/CutsceneKit/Classes/CKSequence.html)

## Creating Custom CKActions

There is a lot of power in extending CKAction to create reusable cutscene features. Included in this framework is [CKDialogueAction](http://veeneck.github.io/CutsceneKit/Classes/CKDialogueAction.html) which manages groups of text in the cutscene. View the source code of that file as a starting reference.

## Working with CKVideoNode

Instead of using nodes and the in game engine to show a cutscene, it may be desirable to use a video instead. The goal of [CKVideoNode](http://veeneck.github.io/CutsceneKit/Classes/CKVideoNode.html) is to make it convenient to combine AVPlayer with SKVideoNode and to add additional functionality. A basic example would be:

    self.videoPlayer = CKVideoNode(name: "MovieName", ext: "mov")
    self.videoPlayer.registerCompletionCallback({
        self.videoFinishedPlaying()
    })
    self.addChild(self.videoPlayer)
    self.videoPlayer.play()

The code above provides completion callback to the video. Additional methods are exposed like `skipToEnd` which would jump to the end of a video and cleanup, or `addTimingHook` which will execute a block of code at a given timestamp.

## Status

Not ready for use.

Repository is public and may be of use, but it is not supported as an open source project. Future changes could be breaking.

## Documentation

Docs are located at [veeneck.github.io/CutsceneKit](http://veeneck.github.io/CutsceneKit) and are generated with [Jazzy](https://github.com/Realm/jazzy). The config file for the documentation is in the project as `config.yml`. Docs can be generated by running this command **in** the project directory:

    jazzy --config {PATH_TO_REPOSITORY}/CutsceneKit/CutsceneKit/config.yml

**Note**: The output in the `config.yml` is hard coded to one computer. Edit the file and update the `output` flag to a valid location.
