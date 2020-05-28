//
//  MenuScene.swift
//  Ragdoll Run
//
//  Created by Jacob Leiken on 5/28/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene {
            
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
        title.fontColor = UIColor(red: 0.67, green: 0.43, blue: 0.06, alpha: 1.0)
        title.fontName = "AvenirNext-Heavy"
        title.position = CGPoint(x: 0, y: topOrBottom*2/3)
        scene!.addChild(title)
        
        // add the buttons
        let playBut = makeButton(text: "Play 🏃‍♀️", name: PLAY_NAME)
        playBut.position = CGPoint(x: 0, y: topOrBottom/4)
        scene!.addChild(playBut)
        
        let customizeBut = makeButton(text: "Customize 🎨", name: CUSTOMIZE_NAME)
        customizeBut.position = .zero
        scene!.addChild(customizeBut)
        
        // add score counter
        let score = SKLabelNode(text: "High Score: \(highScore)")
        score.fontColor = title.fontColor
        score.fontName = "AvenirNext-DemiBold"
        score.position = CGPoint(x: 0, y: -topOrBottom*2/3)
        scene!.addChild(score)
    }
    
    func makeButton(text: String, name: String) -> SKNode {
        let textNode = SKLabelNode(text: text)
        textNode.name = name
        textNode.verticalAlignmentMode = .center
        textNode.horizontalAlignmentMode = .center
        textNode.fontColor = .white
        textNode.fontName = "AvenirNext-DemiBold"
        textNode.position = CGPoint(x: 0, y: 0)
        
        let textSize = NSString(string: text).size(withAttributes: [.font: UIFont(name: textNode.fontName!, size: textNode.fontSize)!])
        let buttonSize = CGSize(width: textSize.width + (scene?.size.width ?? 0)/20, height: scene!.size.height / 15)
        let but = SKSpriteNode(color: .black, size: buttonSize)
        but.name = name
        but.addChild(textNode)
        
        return but
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: scene!)
            let touchedNode = self.atPoint(pos)

            switch touchedNode.name {
            case PLAY_NAME:
                view?.presentScene(
                    GameScene(fileNamed: "GameScene")!,
                    transition: SKTransition.doorsOpenHorizontal(withDuration: 0.2))
            default:
                break
            }
        }
    }
}
