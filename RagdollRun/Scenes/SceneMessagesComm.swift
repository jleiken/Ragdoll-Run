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
    var _translator: MessagesSceneTranslator?
    var translator: MessagesSceneTranslator? {
        get { return _translator }
        set { _translator = newValue }
    }
    
    func presentScene(_ view: SKView?, _ scene: SKScene, transition: SKTransition) {
        if let t = translator, let mScene = scene as? MessagesScene {
            t.toScene(to: mScene, with: transition)
        } else {
            view?.presentScene(scene, transition: transition)
        }
    }
    
    func makeScene(of sceneClass: MessagesScene.Type, with file: String) -> MessagesScene {
        guard let newScene = sceneClass.init(fileNamed: file) else { fatalError("Could not initialize \(sceneClass)") }
        newScene.translator = _translator
        return newScene
    }
}

protocol MessagesSceneTranslator: UIViewController {
    func toScene(to scene: MessagesScene, with transition: SKTransition)
}
