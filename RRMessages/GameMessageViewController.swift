//
//  GameMessageViewController.swift
//  Ragdoll Run
//
//  Created by Jacob Leiken on 6/5/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import UIKit
import SpriteKit

class GameMessageViewController: ViewControllerTransferer {
    
    static let storyboardID = "GameMessageViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = GameScene(fileNamed: "GameScene") {
                setAndPresent(view, scene)
            }
            
            view.ignoresSiblingOrder = true
        }
    }
    
    func setAndPresent(_ view: SKView, _ scene: MessagesScene) {
        // Set the scale mode to resize to fit the window
        scene.scaleMode = .resizeFill
        // Set the scene's translator to be self
        scene.translator = self
        // Present the scene
        view.presentScene(scene)
    }
}

extension GameMessageViewController: MessagesSceneTranslator {
    
    func toScene(to scene: MessagesScene, with transition: SKTransition) {
        if let view = self.view as! SKView? {
            // ignore transition because iMessage is buggy
            setAndPresent(view, scene)
        }
    }
    
}
