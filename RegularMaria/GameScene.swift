//
//  GameScene.swift
//  RegularMaria
//
//  Created by Jacob Leiken on 5/13/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
            
    private var _avatarManager : AvatarManager?
    private var _ground : SKShapeNode?
        
    override func didMove(to view: SKView) {
        // Create the ground
        let groundHeight = -self.size.height / 3
        
        var groundPoints = [CGPoint(x: -self.size.width, y: groundHeight),
                            CGPoint(x: self.size.width, y: groundHeight)]
        _ground = SKShapeNode(points: &groundPoints, count: groundPoints.count)
        _ground!.name = GROUND_NAME
        _ground!.lineWidth = 5
        _ground!.physicsBody = SKPhysicsBody(edgeChainFrom: _ground!.path!)
        initializeStaticPhysicsBody(body: _ground!.physicsBody, GROUND_CONTACT_MASK)
        scene!.addChild(self._ground!)
        
        // initiliaze the avatar
        _avatarManager = AvatarManager(self.scene!, _ground!, groundHeight)
        
        // notify the avatar manager of all collisions
        scene?.physicsWorld.contactDelegate = _avatarManager
        
        // add a camera to the scene
        let cameraNode = SKCameraNode()
        cameraNode.position = scene!.anchorPoint
        
        scene?.addChild(cameraNode)
        scene?.camera = cameraNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _avatarManager?.isTouching = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        _avatarManager?.isTouching = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        _avatarManager?.isTouching = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        _avatarManager?.letAvatarJump()
        
        // move the camera one cameraSpeed increment to the right along with the avatar
        scene?.camera?.position.x += CAMERA_SPEED
        _avatarManager!.walk(CAMERA_SPEED)
    }
}
