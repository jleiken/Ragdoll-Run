//
//  AvatarManager.swift
//  RegularMaria
//
//  Created by Jacob Leiken on 5/14/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import SpriteKit

let CAMERA_MARGIN = 15
let VERT_DY = CGFloat(0.01)

class AvatarManager: NSObject {
    
    private let _scene: SKScene
    private let _fullNode: SKNode
    private let _avatarBody: SKPhysicsBody
    
    private let _cameraToAvatarOffset: CGFloat
    private let _jumpForce: CGFloat
    
    private var _touching: Bool
    var isTouching: Bool {
        get { return _touching }
        set { _touching = newValue }
    }
    
    init(scene: SKScene, groundHeight: CGFloat, color: UIColor, textures: [SKTexture]? = nil) {
        _touching = false
        _scene = scene
        
        // Create the character avatar rectangles
        let torso = SKSpriteNode(color: color, size: sizeByScene(scene, xFactor: 0.03, yFactor: 0.07))
        torso.name = "torso"
        let head = SKSpriteNode(color: color, size: sizeByScene(scene, xFactor: 0.04, yFactor: 0.04))
        head.name = "head"
        let armL = SKSpriteNode(color: color, size: sizeByScene(scene, xFactor: 0.04, yFactor: 0.02))
        armL.name = "armL"
        let armR = SKSpriteNode(color: color, size: sizeByScene(scene, xFactor: 0.04, yFactor: 0.02))
        armR.name = "armR"
        let legL = SKSpriteNode(color: color, size: sizeByScene(scene, xFactor: 0.02, yFactor: 0.05))
        legL.name = "legL"
        let legR = SKSpriteNode(color: color, size: sizeByScene(scene, xFactor: 0.02, yFactor: 0.05))
        legR.name = "legR"
        
        // create the collection of parts and note their indices
        // (I'm using firstIndex in case I ever reorder this array)
        let avatarParts = [torso, head, legL, legR, armL, armR]
        
        // if applicable, set the texture of each body part
        if let bodyTextures = textures {
            if bodyTextures.count == avatarParts.count {
                for i in 0..<avatarParts.count {
                    avatarParts[i].texture = bodyTextures[i]
                }
            } else {
                print("length of textures array did not match number of avatar body parts")
            }
        }
        
        // make required initializations of each body part
        _fullNode = SKNode()
        for part in avatarParts {
            _fullNode.addChild(part)
            part.name = AVATAR_NAME
//            part.physicsBody = SKPhysicsBody(rectangleOf: part.size)
//            part.physicsBody?.restitution = 0.0
        }

        // add the node that contains each body part
        let xPos = -scene.size.width/4
        let nodePos = CGPoint(x: xPos, y: groundHeight+legL.size.height+(torso.size.height*3/7))
        _fullNode.position = nodePos
        scene.addChild(_fullNode)
        
        // set the position of the body parts based on the parent node
        torso.position = scene.convert(CGPoint(x: xPos, y: groundHeight+legL.size.height+(torso.size.height/2)), to: _fullNode)
        head.position = scene.convert(CGPoint(x: xPos, y: groundHeight+legL.size.height+torso.size.height+(head.size.height/2)), to: _fullNode)
        armL.position = scene.convert(CGPoint(x: xPos-(torso.size.width/2+armL.size.width/2), y: groundHeight+legL.size.height+(torso.size.height*2/3)), to: _fullNode)
        armR.position = scene.convert(CGPoint(x: xPos+(torso.size.width/2+armR.size.width/2), y: groundHeight+legL.size.height+(torso.size.height*2/3)), to: _fullNode)
        legL.position = scene.convert(CGPoint(x: xPos-(torso.size.width/2), y: groundHeight+(legL.size.height/2)), to: _fullNode)
        legR.position = scene.convert(CGPoint(x: xPos+(torso.size.width/2), y: groundHeight+(legL.size.height/2)), to: _fullNode)
        
        // define part-specific physics: arms and legs literally don't do anything
//        armL.physicsBody?.collisionBitMask = 0
//        armL.physicsBody?.categoryBitMask = 0
//        armL.physicsBody?.mass = 0.0001
//        armL.physicsBody?.angularDamping = 1.0
//        armR.physicsBody?.collisionBitMask = 0
//        armR.physicsBody?.categoryBitMask = 0
//        armR.physicsBody?.mass = 0.0001
//        armR.physicsBody?.angularDamping = 1.0
//        legL.physicsBody?.collisionBitMask = 0
//        legL.physicsBody?.categoryBitMask = 0
//        legL.physicsBody?.mass = 0.0001
//        legL.physicsBody?.angularDamping = 1.0
//        legR.physicsBody?.collisionBitMask = 0
//        legR.physicsBody?.categoryBitMask = 0
//        legR.physicsBody?.mass = 0.0001
//        legR.physicsBody?.angularDamping = 1.0
        
        // add joints here
//        let shoulder = SKPhysicsJointFixed.joint(withBodyA: torso.physicsBody!, bodyB: head.physicsBody!,
//                                                 anchor: CGPoint(x: xPos, y: head.position.y - (head.size.height / 2)))
//        scene.physicsWorld.add(shoulder)
//        let armJointL = SKPhysicsJointPin.joint(withBodyA: torso.physicsBody!, bodyB: armL.physicsBody!,
//                                                  anchor: CGPoint(x: xPos-(torso.size.width/2), y: armL.position.y))
//        scene.physicsWorld.add(armJointL)
//        let armJointR = SKPhysicsJointPin.joint(withBodyA: torso.physicsBody!, bodyB: armR.physicsBody!,
//                                                  anchor: CGPoint(x: xPos+(torso.size.width/2), y: armR.position.y))
//        scene.physicsWorld.add(armJointR)
//        let legJointL = SKPhysicsJointPin.joint(withBodyA: torso.physicsBody!, bodyB: legL.physicsBody!,
//                                                anchor: CGPoint(x: xPos-(torso.size.width/2), y: groundHeight+legL.size.height))
//        scene.physicsWorld.add(legJointL)
//        let legJointR = SKPhysicsJointPin.joint(withBodyA: torso.physicsBody!, bodyB: legR.physicsBody!,
//                                                anchor: CGPoint(x: xPos+(torso.size.width/2), y: groundHeight+legL.size.height))
//        scene.physicsWorld.add(legJointR)
        
        // create the physics body of the whole thing for ease of reference
        _fullNode.physicsBody = SKPhysicsBody(rectangleOf: sizeByScene(scene, xFactor: 0.05, yFactor: 0.16))
        _avatarBody = _fullNode.physicsBody!
        _avatarBody.restitution = 0.0

        _cameraToAvatarOffset = (scene.camera?.position.x ?? 0) - xPos
        _jumpForce = scene.size.height / 2.5
    }
    
    /// only let the avatar jump if the user's finger is on the screen and the avatar is touching the ground or barely moving (on top of an enemy or pip)
    func letAvatarJump() {
        if _touching && belowVerticalMovement(VERT_DY) && touchingSomething() {
            _avatarBody.applyImpulse(CGVector(dx: 0, dy: _jumpForce))
        }
    }
    
    func belowVerticalMovement(_ dy: CGFloat) -> Bool {
        return _avatarBody.velocity.dy < dy
    }
    
    func touchingSomething() -> Bool {
        return _avatarBody.allContactedBodies().count > 0
    }
    
    /// Increments the position of the avatar by increment.
    /// If the avatar has gotten out of sync with the camera, it will also push it slightly extra towards the camera
    func walk(_ increment: CGFloat) {
        _fullNode.position.x += increment
        
        let cameraOffset = ((_scene.camera?.position.x ?? _fullNode.position.x) - _cameraToAvatarOffset) - _fullNode.position.x
        if Int(abs(cameraOffset)) > CAMERA_MARGIN {
            if cameraOffset < 0 {
                _fullNode.position.x -= 1
            } else {
                _fullNode.position.x += 1
            }
        }
    }
    
    func offScreen() -> Bool {
        return _fullNode.position.y < -_scene.size.height
            || _fullNode.position.x < _scene.camera!.position.x - (_scene.size.width / 2)
    }
}
