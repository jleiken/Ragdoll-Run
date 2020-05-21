//
//  Utils.swift
//  RegularMaria
//
//  Created by Jacob Leiken on 5/14/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import SpriteKit

let AVATAR_CONTACT_MASK = UInt32(0x0000000F)
let GROUND_CONTACT_MASK = UInt32(0x00000001)
let OBJECT_CONTACT_MASK = UInt32(0x00000002)
let ENEMY_CONTACT_MASK = UInt32(0x00000003)

let AVATAR_NAME = "avatar"
let GROUND_NAME = "ground"
let OBSTACLE_NAME = "obstacle"
let ENEMY_NAME = "enemy"

let MENU_NAME = "menuBut"
let PLAY_NAME = "playBut"

var CAMERA_SPEED = CGFloat(3)

/// initializes characteristics of a static physics body (no bounce or movement)
func initializeStaticPhysicsBody(body cBody: SKPhysicsBody?, _ contactMask: UInt32) {
    if let body = cBody {
        body.restitution = 0.0
        body.isDynamic = false
        body.categoryBitMask = contactMask
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
