//
//  ReadyViewController.swift
//  RagdollRun
//
//  Created by Jacob Leiken on 6/6/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class ReadyViewController: ViewControllerTransferer {
    
    static let storyboardID = "ReadyViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = ReadyScene(fileNamed: "ReadyScene") {
                scene.presenter = presenter
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
        }
    }
}
