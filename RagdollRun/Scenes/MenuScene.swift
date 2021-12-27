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
        let leftOrRight = scene!.size.width/2
        
        // set the background and add clouds
        scene!.backgroundColor = Formats.BACKGROUND
        
        let totalAllowableDuration = 30.0
        let cloudGenerator = CloudGenerator(scene: scene!, groundHeight: -topOrBottom)
        for _ in 0...6 {
            let cloud = cloudGenerator.generateCloud(xPosition: CGFloat.random(in: -leftOrRight...leftOrRight))
            let inverseCloudScale = 1-(cloud.size.width/(scene!.size.width+scene!.size.height))
            let cloudsDuration = totalAllowableDuration * inverseCloudScale
            let cloudOffScreen = leftOrRight+(cloud.size.width/2)
            let distFromLeftPercentage = abs((cloud.position.x+leftOrRight)/scene!.size.width)
            cloud.run(SKAction.sequence([
                SKAction.moveTo(x: -cloudOffScreen, duration: cloudsDuration*distFromLeftPercentage),
                SKAction.repeatForever(SKAction.sequence([
                    SKAction.moveTo(x: cloudOffScreen, duration: 0),
                    SKAction.moveTo(x: -cloudOffScreen, duration: cloudsDuration)
                ]))
            ]))
            scene!.addChild(cloud)
        }
        
        // add a title
        let title = SKLabelNode(text: "Ragdoll Run")
        title.fontSize = 42.0
        title.fontColor = Formats.HIGHLIGHT
        title.fontName = Formats.TITLE_FONT
        title.position = CGPoint(x: 0, y: topOrBottom*2/3)
        scene!.addChild(title)
        
        // add the buttons
        let playBut = makeButton(scene: scene!, text: "Play 🏃‍♀️", name: SpriteNames.PLAY_NAME)
        playBut.position = CGPoint(x: 0, y: topOrBottom/2)
        scene!.addChild(playBut)
        
        let customizeBut = makeButton(scene: scene!, text: "Customize 🎨", name: SpriteNames.CUSTOMIZE_NAME)
        customizeBut.position = CGPoint(x: 0, y: topOrBottom/4)
        scene!.addChild(customizeBut)
        
        // Only let the user remove ads if they're authorized to pay
        if StoreObserver.shared.isAuthorizedForPayments {
            let adsBut = makeButton(scene: scene!, text: "Remove ads", name: SpriteNames.REMOVE_AD_NAME)
            adsBut.position = .zero
            scene!.addChild(adsBut)
            
            let restoreBut = makeButton(scene: scene!, text: "Restore purchases", name: SpriteNames.RESTORE_NAME)
            restoreBut.position = CGPoint(x: 0, y: -topOrBottom/4)
            scene!.addChild(restoreBut)
        }
        
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
            case SpriteNames.REMOVE_AD_NAME:
                StoreManager.shared.paymentRequest(matchingIdentifier: touchedNode.name!)
            case SpriteNames.RESTORE_NAME:
                StoreObserver.shared.restore()
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
        let muteBut = makeButton(scene: scene!, text: text, name: SpriteNames.MUTE_NAME)
        muteBut.position = CGPoint(x: 0, y: -scene!.size.height/4)
        scene!.addChild(muteBut)
    }
}
