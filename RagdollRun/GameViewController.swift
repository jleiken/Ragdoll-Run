//
//  GameViewController.swift
//  RegularMaria
//
//  Created by Jacob Leiken on 5/13/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        StoreObserver.shared.delegate = self
        StoreManager.shared.delegate = self
        StoreManager.shared.startProductRequest()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'MenuScene.sks'
            if let scene = MenuScene(fileNamed: "MenuScene") {
                // Set the scale mode to resize to fit the window
                scene.scaleMode = .resizeFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: StoreAlertDelegate {
    func present(_ alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
}
