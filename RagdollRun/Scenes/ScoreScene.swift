//
//  ScoreScene.swift
//  RagdollRun
//
//  Created by Jacob Leiken on 6/12/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import Foundation
import SpriteKit

class ScoreScene: MessagesScene {
    
    var currentMatch: RunMatch?
    var presenter: MessagesViewPresenter?
    var localID: UUID?
            
    override func didMove(to view: SKView) {
        let topOrBottom = scene!.size.height/2
        
        // set the background and add clouds
        scene!.backgroundColor = Formats.BACKGROUND
        addMenuClouds(scene!)
        
        // add a title
        let title = SKLabelNode(text: "Scores")
        title.fontSize = 42.0
        title.fontColor = Formats.HIGHLIGHT
        title.fontName = Formats.TITLE_FONT
        title.position = CGPoint(x: 0, y: topOrBottom*0.7)
        scene?.addChild(title)
        
        // add a play again button
        let playBut = makeScaledTextButton(scene: scene!, text: "Play again 🏃‍♀️", name: SpriteNames.PLAY_NAME)
        playBut.position = CGPoint(x: 0, y: -topOrBottom*0.7)
        scene?.addChild(playBut)
        
        // display all the available outcomes
        if let outcomes = currentMatch?.particpantScores.sorted() {
            var yInd = topOrBottom/2
            for i in 0..<outcomes.count {
                let outcome = outcomes[i]
                
                var isYou = ""
                if outcome.participant == localID {
                    isYou = " (You)"
                }
                let text = NSAttributedString(string: "\(i+1)\(isYou): \(outcome.score) pts",
                    attributes: [
                        .font: UIFont(name: Formats.LABEL_FONT, size: 28.0)!
                ])
                let label = SKLabelNode(attributedText: text)
                label.numberOfLines = 3
                label.lineBreakMode = .byWordWrapping
                label.fontSize = 18.0
                label.preferredMaxLayoutWidth = scene!.size.width*3/4
                label.verticalAlignmentMode = .center
                label.horizontalAlignmentMode = .left
                label.fontColor = .black
                
                // align the text to the 3/4 left margin
                label.position = CGPoint(x: -scene!.size.width*3/8, y: yInd)
                scene?.addChild(label)
                
                yInd -= text.size().height * 1.25
                // if we had too many participants just cut the losers off
                if yInd < playBut.position.y+text.size().height {
                    break
                }
            }
        } else {
            // if no outcomes are available, add an error
            let noScores = SKLabelNode(text: "No scores to see yet!")
            noScores.fontColor = .red
            noScores.fontName = Formats.LABEL_FONT
            noScores.position = .zero
            scene?.addChild(noScores)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: scene!)
            let touchedNode = self.atPoint(pos)

            switch touchedNode.name {
            case SpriteNames.PLAY_NAME:
                presenter?.clearConversation()
                presenter?.markReady(false)
                presenter?.presentMessagesView(newView: .ready)
            default:
                break
            }
        }
    }
}
