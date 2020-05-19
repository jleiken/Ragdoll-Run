//
//  AvatarManager.swift
//  RegularMaria
//
//  Created by Jacob Leiken on 5/14/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import SpriteKit

class AvatarManager: NSObject, SKPhysicsContactDelegate {
    
    private var _avatar: SKSpriteNode
    
    private var _ground: SKShapeNode
    
    private var _touching: Bool
    var isTouching: Bool {
        get { return _touching }
        set { _touching = newValue }
    }
    
    init(_ scene: SKScene, _ ground: SKShapeNode, _ groundHeight: CGFloat) {
        _touching = false
        _ground = ground
        
        // Create the character avatar
        let w = (scene.size.width + scene.size.height) * 0.05
        let h = (scene.size.width + scene.size.height) * 0.10
        
        _avatar = SKSpriteNode(color: SKColor.green, size: CGSize.init(width: w, height: h))
        _avatar.name = AVATAR_NAME
        
        // define avatar physics
        _avatar.physicsBody = SKPhysicsBody(rectangleOf: _avatar.size)
        ///_avatar.physicsBody!.usesPreciseCollisionDetection = true // only if there start being weird missed collisions
        _avatar.physicsBody!.restitution = 0.0
        _avatar.physicsBody!.collisionBitMask = AVATAR_CONTACT_MASK
        
        // add avatar to the scene and set its position
        scene.addChild(_avatar)
        _avatar.position = CGPoint.init(x: 0, y: groundHeight+5)
        
    }
    
    func letAvatarJump() {
        // if the avatar is in contact with the floor, let them jump again
        if _touching &&  _avatar.physicsBody!.allContactedBodies().contains((_ground.physicsBody)!) {
            _avatar.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 200))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print(contact)
        // if the contact was between the avatar and an obstacle, game over!
        if contact.bodyA.node?.name == OBSTACLE_NAME || contact.bodyB.node?.name == OBSTACLE_NAME {
            _avatar.color = SKColor.red
        }
    }
    
    func walk(_ increment: CGFloat) {
        _avatar.position.x += increment
    }
    
    func offScreen() -> Bool {
        return _avatar.position.y < -_avatar.scene!.size.height
    }
    
    func removeSelf() {
        _avatar.removeFromParent()
    }
}
