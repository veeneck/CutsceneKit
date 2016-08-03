//
//  CKDialogueAction.swift
//  CutsceneKit
//
//  Created by Ryan Campbell on 11/18/15.
//  Copyright © 2015 Phalanx Studios. All rights reserved.
//

import SpriteKit

/**
    The purpose of this class is to provide an example of how CKAction can be subclassed to enapsulate common cutscene features. For this specific use case, sequences of dialogue can be added.
    
        let action = CKDialogueAction(
            node: nodeA,
            position: CGPoint(x:0, y:0),
            duration:3, 
            text:"Hello World")
        self.cutscene.addSequences([CKSequence(actions: [action])])
 
    The example code above would add a text string of "Hello World" to `nodeA` for 3 seconds.
*/
public class CKDialogueAction : CKAction {
    
    /**
    Initialize by creating your own SKLabelNode. The label will be assigned a default action to add it to the provided `node` where it will remain for the set `duration`.
     
    - parameter node: The node to make the label a child of.
    - parameter duration: The length of time for the label to appear.
    - parameter label: The SKLabelNode to use.
    */
    public init(node:SKNode, duration:Double, label:SKLabelNode) {
        label.name = "CKActionObject"
        super.init(
            node: node,
            action: CKDialogueAction.buildActionForLabel(label: label, parent: node, duration: duration))
    }
    
    /**
     Convenience initializer that creates a SKLabelNode with default settings. The label will be assigned a default action to add it to the provided `node` where it will remain for the set `duration`.
     
     - parameter node: The node to make the label a child of.
     - parameter position: The position of the SKLabelNode in the coordinate system of `node`
     - parameter duration: The length of time for the label to appear.
     - parameter text: The string for the label.
     */
    public convenience init(node:SKNode, position:CGPoint, duration:Double, text:String) {
        let label = CKDialogueAction.createSKLabelNode(text: text, position: position)
        self.init(node:node, duration:duration, label:label)
    }
    
    /// Factory method to create a SKLabelNode with default settings.
    private class func createSKLabelNode(text:String, position:CGPoint) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "Anivers-Regular")
        label.text = text
        label.fontSize = 40
        label.zPosition = 20000
        label.fontColor = SKColor.white
        label.horizontalAlignmentMode = .center
        label.position = position
        return label
    }
    
    /// Factory method to create the SKAction that will add the SKLabelNode to the target node, and wait for the set duration.
    private class func buildActionForLabel(label:SKLabelNode, parent:SKNode, duration:Double) -> SKAction {
        return SKAction.group([
            SKAction.wait(forDuration: duration),
            SKAction.run({
                parent.addChild(label)
            })
        ])
    }
    
}
