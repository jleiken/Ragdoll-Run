//
//  CustomizeScene.swift
//  RagdollRun
//
//  Created by Jacob Leiken on 5/31/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import SpriteKit

class CustomizeScene: SKScene {
            
    override func didMove(to view: SKView) {
        let topOrBottom = scene!.size.height/2
        
        // set the background
        let background = SKSpriteNode(imageNamed: "BackgroundImage")
        background.size = scene!.size
        background.zPosition = -1.0
        scene!.addChild(background)
        
        // add a title
        let title = SKLabelNode(text: "Customize your avatar")
        title.fontSize = 28.0
        title.fontColor = ORANGE
        title.fontName = TITLE_FONT
        title.position = CGPoint(x: 0, y: topOrBottom*2/3)
        scene!.addChild(title)
        
        // back button
        let backBut = makeLabel(text: "< Back")
        backBut.fontColor = .black
        backBut.fontSize = 20.0
        backBut.name = BACK_NAME
        backBut.position = CGPoint(x: -scene!.size.width*3/8, y: topOrBottom - scene!.size.height/15)
        scene!.addChild(backBut)
        
        // coin count indicator
        let coinIndicator = makeLabel(text: "💰 \(coinCount)")
        coinIndicator.fontColor = .black
        coinIndicator.fontSize = 20.0
        coinIndicator.position = CGPoint(x: scene!.size.width*1/3, y: backBut.position.y)
        scene!.addChild(coinIndicator)
        
        // grid of skins that can be unlocked
        
    }
    
    func makeGrid(items: [[String: SKTexture]]) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: scene!)
            let touchedNode = self.atPoint(pos)

            switch touchedNode.name {
            case BACK_NAME:
                view?.presentScene(
                    MenuScene(fileNamed: "MenuScene")!,
                    transition: SKTransition.fade(withDuration: 0.2))
            default:
                break
            }
        }
    }
}
