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
        
        // set the background
        let background = SKSpriteNode(imageNamed: "BackgroundImage")
        background.size = scene!.size
        background.zPosition = -1.0
        scene!.addChild(background)
        
        // add a title
        let title = SKLabelNode(text: "Ragdoll Run")
        title.fontSize = 42.0
        title.fontColor = Formats.HIGHLIGHT
        title.fontName = Formats.TITLE_FONT
        title.position = CGPoint(x: 0, y: topOrBottom*2/3)
        scene!.addChild(title)
        
        // add the buttons
        let playBut = makeButton(scene: scene!, text: "Play 🏃‍♀️", name: SpriteNames.PLAY_NAME)
        playBut.position = CGPoint(x: 0, y: topOrBottom/4)
        scene!.addChild(playBut)
        
        let customizeBut = makeButton(scene: scene!, text: "Customize 🎨", name: SpriteNames.CUSTOMIZE_NAME)
        customizeBut.position = .zero
        scene!.addChild(customizeBut)
        
        // Only let the user remove ads if they're authorized to pay
        if StoreObserver.shared.isAuthorizedForPayments {
            let adsBut = makeButton(scene: scene!, text: "Remove ads", name: SpriteNames.REMOVE_AD_NAME)
            adsBut.position = CGPoint(x: 0, y: -topOrBottom/4)
            scene!.addChild(adsBut)
        }
        
        // add score counter
        let score = SKLabelNode(text: "High Score: \(highScore)")
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
            default:
                break
            }
        }
    }
}
