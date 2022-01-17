//
//  MenuScene.swift
//  Ragdoll Run
//
//  Created by Jacob Leiken on 5/28/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import SpriteKit

class MenuScene: MessagesScene {
            
    override func didMove(to view: SKView) {
        let topOrBottom = scene!.size.height/2
        
        // set the background and add clouds
        scene!.backgroundColor = Formats.BACKGROUND
        addMenuClouds(scene!)
        
        // add a title
        let title = SKLabelNode(text: "Ragdoll Run")
        title.fontSize = 42.0
        title.fontColor = Formats.HIGHLIGHT
        title.fontName = Formats.TITLE_FONT
        title.position = CGPoint(x: 0, y: topOrBottom*2/3)
        scene!.addChild(title)
        
        // add the buttons
        let playBut = makeScaledTextButton(scene: scene!, text: "Play 🏃‍♀️", name: SpriteNames.PLAY_NAME)
        playBut.position = CGPoint(x: 0, y: topOrBottom/2)
        scene!.addChild(playBut)
        
        let customizeBut = makeScaledTextButton(scene: scene!, text: "Customize 🎨", name: SpriteNames.CUSTOMIZE_NAME)
        customizeBut.position = CGPoint(x: 0, y: topOrBottom/6)
        scene!.addChild(customizeBut)
        
        // mute button, draw for the first time
        redrawMuteButton()
        
        // add score counter
        let score = SKLabelNode(text: "High Score: \(CloudVars.highScore)")
        score.fontColor = title.fontColor
        score.fontName = Formats.LABEL_FONT
        score.position = CGPoint(x: 0, y: -topOrBottom*2/3)
        scene!.addChild(score)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: scene!)
            let touchedNode = self.atPoint(pos)

            switch touchedNode.name {
            case SpriteNames.PLAY_NAME:
                presentScene(
                    view, makeScene(of: GameScene.self, with: "GameScene"),
                    transition: SKTransition.doorsOpenHorizontal(withDuration: 0.2))
            case SpriteNames.CUSTOMIZE_NAME:
                presentScene(
                    view, makeScene(of: CustomizeScene.self, with: "CustomizeScene"),
                    transition: SKTransition.fade(withDuration: 0.2))
            case SpriteNames.MUTE_NAME:
                CloudVars.muted = !CloudVars.muted
                redrawMuteButton()
            default:
                break
            }
        }
    }
    
    /// Removes the mute button from the scene if it exists and replaces it with a button reflecting the new value
    func redrawMuteButton() {
        if let existing = scene?.childNode(withName: SpriteNames.MUTE_NAME) {
            existing.removeFromParent()
        }
        
        var text = "🔈"
        if CloudVars.muted {
            text = "🔇"
        }
        let muteBut = makeScaledTextButton(scene: scene!, text: text, name: SpriteNames.MUTE_NAME)
        muteBut.position = CGPoint(x: 0, y: -scene!.size.height/4)
        scene!.addChild(muteBut)
    }
}
