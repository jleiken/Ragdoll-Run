//
//  Utils.swift
//  RegularMaria
//
//  Created by Jacob Leiken on 5/14/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import SpriteKit

let AVATAR_CONTACT_MASK = UInt32(0x0000000F)
let COIN_CONTACT_MASK = UInt32(0b1)

let AVATAR_NAME = "avatar"
let GROUND_NAME = "ground"
let OBSTACLE_NAME = "obstacle"
let ENEMY_NAME = "enemy"

let MENU_NAME = "menuBut"
let PLAY_NAME = "playBut"
let BACK_NAME = "backBut"
let REMOVE_AD_NAME = "removeAddBut"
let NO_SOUND_NAME = "toggleSoundBut"
let CUSTOMIZE_NAME = "customizeBut"

let ORANGE = UIColor(red: 0.67, green: 0.43, blue: 0.06, alpha: 1.0)
let TITLE_FONT = "AvenirNext-Heavy"
let EMPHASIS_FONT = "AvenirNext-Bold"
let LABEL_FONT = "AvenirNext-DemiBold"

let SCORE_KEY = "highScore"
let COIN_KEY = "coinCount"

var CAMERA_SPEED = CGFloat(3)

/// initializes characteristics of a static physics body (no bounce or movement)
func initializeStaticPhysicsBody(body cBody: SKPhysicsBody?) {
    if let body = cBody {
        body.restitution = 0.0
        body.isDynamic = false
    }
}

/// returns true if the node is part of the "world", that is ground, obstacle, or enemy, rather than avatar or camera
func nodeIsWorld(node: SKNode) -> Bool {
    return node.name == GROUND_NAME || node.name == OBSTACLE_NAME || node.name == ENEMY_NAME
}

/// generates a CGSize that is a factor the scene's size, scaled by xFactor and yFactor
func sizeByScene(_ scene: SKScene, xFactor: CGFloat, yFactor: CGFloat) -> CGSize {
    let w = (scene.size.width + scene.size.height) * xFactor
    let h = (scene.size.width + scene.size.height) * yFactor
    
    return CGSize(width: w, height: h)
}

/// makes a button based on the given scene
func makeButton(scene: SKScene, text: String, name: String) -> SKNode {
    let textNode = makeLabel(text: text)
    textNode.name = name
    textNode.position = CGPoint(x: 0, y: 0)
    
    let textSize = NSString(string: text).size(withAttributes: [.font: UIFont(name: textNode.fontName!, size: textNode.fontSize)!])
    let buttonSize = CGSize(width: textSize.width + scene.size.width/20, height: scene.size.height / 15)
    let but = SKSpriteNode(color: .black, size: buttonSize)
    but.name = name
    but.addChild(textNode)
    
    return but
}

/// makes a label with the given text
func makeLabel(text: String) -> SKLabelNode {
    let textNode = SKLabelNode(text: text)
    textNode.verticalAlignmentMode = .center
    textNode.horizontalAlignmentMode = .center
    textNode.fontColor = .white
    textNode.fontName = LABEL_FONT
    
    return textNode
}

var _highScore: Int64 = -1
var highScore: Int64 {
    /// checks with CloudKit if highScore has been pulled or set yet
    get {
        if _highScore == -1 {
            // may not exist, but default is 0 anyway
            _highScore = NSUbiquitousKeyValueStore.default.longLong(forKey: SCORE_KEY)
        }
        return _highScore
    }
    /// sets in CloudKit and locally
    set {
        _highScore = newValue
        NSUbiquitousKeyValueStore.default.set(newValue, forKey: SCORE_KEY)
    }
}

var _coinCount: Int64 = -1
var coinCount: Int64 {
    /// checks with CloudKit if the coin count has been pulled or set yet
    get {
        if _coinCount == -1 {
            // may not exist, but default is 0 anyway
            _coinCount = NSUbiquitousKeyValueStore.default.longLong(forKey: COIN_KEY)
        }
        return _coinCount
    }
    /// sets in CloudKit and locally
    set {
        _coinCount = newValue
        NSUbiquitousKeyValueStore.default.set(newValue, forKey: COIN_KEY)
    }
}
