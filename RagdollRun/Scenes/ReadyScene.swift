//
//  ReadyScene.swift
//  RagdollRun
//
//  Created by Jacob Leiken on 1/14/22.
//  Copyright © 2022 Jacob Leiken. All rights reserved.
//

import Foundation
import SpriteKit

class ReadyScene: MessagesScene
{
    var presenter: MessagesViewPresenter?
    
    override func didMove(to view: SKView) {
        let topOrBottom = scene!.size.height/2
        
        // set the background and add clouds
        scene!.backgroundColor = Formats.BACKGROUND
        addMenuClouds(scene!)
        
        // add a title
        let title = SKLabelNode(text: "Start 🏃")
        title.fontSize = 42.0
        title.fontColor = Formats.HIGHLIGHT
        title.fontName = Formats.TITLE_FONT
        title.position = CGPoint(x: 0, y: topOrBottom*0.1)
        scene?.addChild(title)
        
        // add the ready button
        let readyBut = makeScaledTextButton(scene: scene!, text: "Ready?", name: SpriteNames.PLAY_NAME)
        readyBut.position = .zero
        scene?.addChild(readyBut)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: scene!)
            let touchedNode = self.atPoint(pos)

            switch touchedNode.name {
            case SpriteNames.PLAY_NAME:
                presenter?.clearConversation()
                presenter?.markReady(false)
                presenter?.presentMessagesView(newView: .play)
            default:
                break
            }
        }
    }
}
