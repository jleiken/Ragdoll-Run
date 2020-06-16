//
//  SceneMessageComm.swift
//  RagdollRun
//
//  Created by Jacob Leiken on 6/5/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import Foundation
import SpriteKit

class MessagesScene: SKScene {
    var translator: MessagesSceneTranslator?
    var controller: UIViewController?
    
    func presentScene(_ view: SKView?, _ scene: MessagesScene, transition: SKTransition) {
        scene.controller = controller
        if let t = translator {
            t.toScene(to: scene, with: transition)
        } else {
            view?.presentScene(scene, transition: transition)
        }
    }
    
    func makeScene(of sceneClass: MessagesScene.Type, with file: String) -> MessagesScene {
        guard let newScene = sceneClass.init(fileNamed: file) else { fatalError("Could not initialize \(sceneClass)") }
        newScene.translator = translator
        return newScene
    }
}

protocol MessagesSceneTranslator: UIViewController {
    func toScene(to scene: MessagesScene, with transition: SKTransition)
}
