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

let AVATAR_NAME = "avatar"
let GROUND_NAME = "ground"
let OBSTACLE_NAME = "obstacle"

let MENU_NAME = "menuBut"
let PLAY_NAME = "playBut"

var CAMERA_SPEED = CGFloat(3)

func initializeStaticPhysicsBody(body cBody: SKPhysicsBody?, _ contactMask: UInt32) {
    if let body = cBody {
        body.restitution = 0.0
        body.isDynamic = false
        ///body.collisionBitMask = contactMask
    }
}
