//
//  AvatarManager.swift
//  RegularMaria
//
//  Created by Jacob Leiken on 5/14/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import SpriteKit

let CAMERA_MARGIN = 15

class AvatarManager: NSObject, SKPhysicsContactDelegate {
    
    private var _avatar: SKSpriteNode
    
    private let _cameraToAvatarOffset: CGFloat
    
    private var _touching: Bool
    var isTouching: Bool {
        get { return _touching }
        set { _touching = newValue }
    }
    
    init(_ scene: SKScene, _ groundHeight: CGFloat) {
        _touching = false
        
        // Create the character avatar
        _avatar = SKSpriteNode(color: .orange, size: sizeByScene(scene, xFactor: 0.05, yFactor: 0.10))
        _avatar.name = AVATAR_NAME
        
        // define avatar physics
        _avatar.physicsBody = SKPhysicsBody(rectangleOf: _avatar.size)
        //_avatar.physicsBody!.usesPreciseCollisionDetection = true // only if there start being weird missed collisions
        _avatar.physicsBody!.restitution = 0.0
        _avatar.physicsBody!.collisionBitMask = AVATAR_CONTACT_MASK
        
        // add avatar to the scene and set its position
        _avatar.position = CGPoint(x: -scene.size.width/4, y: groundHeight+5)
        scene.addChild(_avatar)

        _cameraToAvatarOffset = (scene.camera?.position.x ?? 0) - _avatar.position.x
    }
    
    func letAvatarJump() {
        // if the avatar is in contact with the floor, let them jump again
        if _touching {
            let contactedBodies = _avatar.physicsBody!.allContactedBodies()
            for body in contactedBodies {
                if body.node?.name ?? "" == GROUND_NAME {
                    _avatar.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 200))
                    // only apply the impulse once
                    return
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print(contact)
        // if the contact was between the avatar and an obstacle, game over!
        if contact.bodyA.node?.name == OBSTACLE_NAME || contact.bodyB.node?.name == OBSTACLE_NAME {
            _avatar.color = SKColor.red
        }
    }
    
    /// Increments the position of the avatar by increment.
    /// If the avatar has gotten out of sync with the camera, it will also push it slightly extra towards the camera
    func walk(_ increment: CGFloat) {
        _avatar.position.x += increment
        let cameraOffset = ((_avatar.scene?.camera?.position.x ?? _avatar.position.x) - _cameraToAvatarOffset) - _avatar.position.x
        if Int(abs(cameraOffset)) > CAMERA_MARGIN {
            if cameraOffset < 0 {
                _avatar.position.x -= 1
            } else {
                _avatar.position.x += 1
            }
        }
    }
    
    func offScreen() -> Bool {
        return _avatar.position.y < -_avatar.scene!.size.height
    }
    
    func removeSelf() {
        _avatar.removeFromParent()
    }
}
