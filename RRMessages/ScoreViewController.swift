//
//  ScoreViewController.swift
//  Ragdoll Run
//
//  Created by Jacob Leiken on 6/6/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class ScoreViewController: ViewControllerTransferer {
    
    static let storyboardID = "ScoreViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // TODO: scores, not game
            if let scene = GameScene(fileNamed: "GameScene") {
                scene.scaleMode = .resizeFill
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
        }
    }
    
}
