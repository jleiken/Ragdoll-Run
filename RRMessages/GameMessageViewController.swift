//
//  GameMessageViewController.swift
//  Ragdoll Run
//
//  Created by Jacob Leiken on 6/5/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import UIKit
import SpriteKit

class GameMessageViewController: UIViewController {
    
    static let storyboardID = "GameMessageViewController"
    
    weak var delegate: RRViewControllerDelegate?
    
    var _currentMatch: RunMatch?
    var currentMatch: RunMatch? {
        get { return _currentMatch }
        set { _currentMatch = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if _currentMatch != nil && currentMatch?.active ?? false {
                // We got here from an iMessage challenge, skip the Menu and immediately start the game
                if let scene = GameScene(fileNamed: "GameScene") {
                    setAndPresent(view, scene)
                }
            } else {
                // Load the SKScene from 'MenuScene.sks'
                if let scene = MenuScene(fileNamed: "MenuScene") {
                    setAndPresent(view, scene)
                }
            }
            
            view.ignoresSiblingOrder = true
        }
    }
    
    func toScene(to scene: MessagesScene, with transition: SKTransition) {
        if let view = self.view as! SKView? {
            scene.scaleMode = .resizeFill
            scene.translator = self
            view.presentScene(scene, transition: transition)
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portraitUpsideDown
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameMessageViewController: MessagesSceneTranslator {
    
    func setAndPresent(_ view: SKView, _ scene: MessagesScene) {
        // Set the scale mode to resize to fit the window
        scene.scaleMode = .resizeFill
        // Set the scene's translator to be self
        scene.translator = self
        // Present the scene
        view.presentScene(scene)
    }
    
}
