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
    
    private var groundHeight : CGFloat?
    
    private var avatar : SKSpriteNode?
    private var ground : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        // Create the ground
        self.groundHeight = -self.size.height / 3
        var groundPoints = [CGPoint(x: -self.size.width, y: self.groundHeight!),
                            CGPoint(x: 5 * self.size.width, y: self.groundHeight!)]
        self.ground = SKShapeNode(points: &groundPoints, count: groundPoints.count)
        ground!.lineWidth = 5
        ground!.physicsBody = SKPhysicsBody(edgeChainFrom: ground!.path!)
        ground!.physicsBody!.restitution = 0.0
        ground!.physicsBody!.friction = 1.0
        ground!.physicsBody!.isDynamic = false
        scene!.addChild(self.ground!)
        
        // Create the character avatar
        let w = (self.size.width + self.size.height) * 0.05
        let h = (self.size.width + self.size.height) * 0.10
        self.avatar = SKSpriteNode(color: SKColor.green, size: CGSize.init(width: w, height: h))
        self.avatar!.position = CGPoint.init(x: 0, y: self.groundHeight!+5)
        self.avatar!.physicsBody = SKPhysicsBody(rectangleOf: self.avatar!.size)
        self.avatar!.physicsBody!.affectedByGravity = true
        self.avatar!.physicsBody!.isDynamic = true
        self.avatar!.physicsBody!.usesPreciseCollisionDetection = true
        self.avatar!.physicsBody!.restitution = 0.0
        scene!.addChild(self.avatar!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let avatar = self.avatar {
            // if the avatar is back on the floor, let them jump again
            let avatarBottom = avatar.position.y-(avatar.size.height/2)
            print(avatarBottom)
            if (avatarBottom - self.groundHeight!) < 1.5 {
                print("it happened")
                avatar.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1000))
            }
        }
        
        // mayve switch to detect a collision between the ground and character and if there's a collision and someone clicked then apply the force?
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
