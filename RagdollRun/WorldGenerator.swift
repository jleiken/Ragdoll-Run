//
//  WorldGenerator.swift
//  RegularMaria
//
//  Created by Jacob Leiken on 5/20/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import SpriteKit
import GameplayKit

let CHUNK_SIZE = CGFloat(7500)
let GROUND_COLOR = SKColor.white

let ENEMY_COLOR = SKColor.red
let PIPE_COLOR = SKColor.green

class WorldGenerator {
    private var _renderedTo : CGFloat
    private var _groundHeight : CGFloat
    private var _scene : SKScene
    
    private var ENEMY_FREQ = 15
    private var PIPE_FREQ = 10
    /// the percantage likeliness that a hole is generated at each tick, out of 100
    private var HOLE_FREQ = 5
    private let HOLE_SIZE : CGFloat
    
    private let _enemyMovementSequence : SKAction
    
    init(groundHeight : CGFloat, startingPos : CGFloat, scene : SKScene) {
        _renderedTo = startingPos
        _groundHeight = groundHeight
        HOLE_SIZE = abs(_groundHeight / 1.4)
        _scene = scene
        
        _enemyMovementSequence = SKAction.repeatForever(SKAction.sequence([
            SKAction.moveBy(x: _scene.size.width * 0.4, y: 0, duration: 0.4),
            SKAction.wait(forDuration: 0.1),
            SKAction.moveBy(x: -_scene.size.width * 0.4, y: 0, duration: 0.4),
            SKAction.wait(forDuration: 0.1),
        ]))
    }
    
    func renderChunk(size: CGFloat) {
        var from = _renderedTo
        let to = _renderedTo + size
        print("rendering from \(from) to \(to)")
        
        deleteOldChunk()
        
        generateGroundWithHoles(from, to)
        if from < 0 {
            // if we're starting out now, don't generate dangers right away
            from = -_renderedTo
        }
        generateDangers(from, to)
        
        _renderedTo = to
    }
    
    /// Deletes everything a chunk behind the camera's position
    func deleteOldChunk() {
        let deleteBefore = (_scene.camera?.position.x ?? CHUNK_SIZE) - CHUNK_SIZE
        for child in _scene.children {
            if nodeIsWorld(node: child) && child.position.x < deleteBefore {
                child.removeFromParent()
            }
        }
    }
    
    /// Generate ground from-to with holes placed at HOLE_FREQ%
    func generateGroundWithHoles(_ from: CGFloat, _ to: CGFloat) {
        // go from from to to and at each point that's more than HOLE_SIZE ticks away from a hole,
        // give it HOLE_FREQ% chance of generating a new hole
        // (because we don't want two holes in a row)
        var prevWasHole = true
        let fromI = Int(from/HOLE_SIZE)
        let toI = Int(to/HOLE_SIZE)
        for i in fromI..<toI {
            // hole if random number from 0-100 is < HOLE_FREQ
            var shouldBeHole = randLessThan(HOLE_FREQ)
            if prevWasHole {
                shouldBeHole = false
                prevWasHole = false
            }
            
            if shouldBeHole {
                // if the current chunk should be a hole, mark that it was and continue
                prevWasHole = true
                continue
            }
            
            // if it shouldn't be a whole, make a rectangle for the ground
            let ground = SKSpriteNode(color: GROUND_COLOR, size: CGSize(width: HOLE_SIZE+2, height: abs(_groundHeight)))
            // position is x: nextStart, y: bottom of the screen
            ground.position = CGPoint(x: CGFloat(i) * HOLE_SIZE, y: _groundHeight * 1.5)
            ground.name = GROUND_NAME
            ground.zPosition = 0
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            initializeStaticPhysicsBody(body: ground.physicsBody, GROUND_CONTACT_MASK)
            _scene.addChild(ground)
        }
    }

    /// Once the ground is generated, generate enemies and obstacles from-to based on ENEMY_FREQ and PIPE_FREQ
    func generateDangers(_ from: CGFloat, _ to: CGFloat) {
        var index = from
        while index < to {
            var toIncrement = HOLE_SIZE
            if _scene.atPoint(CGPoint(x: index, y: _groundHeight-5)).name == GROUND_NAME {
                // there's ground here, so think about adding a pipe or enemy
                let genEnemy = randLessThan(ENEMY_FREQ)
                var genPipe = randLessThan(PIPE_FREQ)
                
                // if both are true, just add the harder thing, the enemy
                if genEnemy && genPipe {
                    genPipe = false
                }
                
                if genEnemy {
                    addEnemy(x: index)
                    // enemies are the hardest thing to counter, so skip many HOLE_SIZEs
                    toIncrement = HOLE_SIZE * 3
                } else if genPipe {
                    addPipe(x: index)
                    // pipes aren't so hard to counter, so skip two HOLE_SIZEs
                    toIncrement = HOLE_SIZE * 2
                }
            }
            
            index += toIncrement
        }
    }
    
    func addEnemy(x: CGFloat) {
        let xSize = _scene.size.width * 0.1
        let ySize = _scene.size.height * 0.1
        var enemyPoints = [
            CGPoint(x: x+xSize, y: _groundHeight+ySize),
            CGPoint(x: x, y: _groundHeight),
            CGPoint(x: x+(xSize*3), y: _groundHeight),
            CGPoint(x: x+(xSize*2), y: _groundHeight+ySize),
        ]
        let enemy = SKShapeNode(points: &enemyPoints, count: enemyPoints.count)
        enemy.fillColor = ENEMY_COLOR
        enemy.lineWidth = 0.0
        enemy.physicsBody = SKPhysicsBody(polygonFrom: enemy.path!)
        initializeStaticPhysicsBody(body: enemy.physicsBody, ENEMY_CONTACT_MASK)
        
        // add enemy movement
        enemy.run(_enemyMovementSequence)
        _scene.addChild(enemy)
    }
    
    func addPipe(x: CGFloat) {
        let pipeBase = SKSpriteNode(color: PIPE_COLOR, size: sizeByScene(_scene, xFactor: 0.05, yFactor: 0.12))
        pipeBase.position = CGPoint(x: x, y: _groundHeight+pipeBase.size.height/2)
        pipeBase.physicsBody = SKPhysicsBody(rectangleOf: pipeBase.size)
        initializeStaticPhysicsBody(body: pipeBase.physicsBody, OBJECT_CONTACT_MASK)
        
        let pipeTop = SKSpriteNode(color: PIPE_COLOR, size: sizeByScene(_scene, xFactor: 0.06, yFactor: 0.03))
        pipeTop.position = CGPoint(x: x, y: pipeBase.position.y+pipeBase.size.height/2)
        pipeTop.physicsBody = SKPhysicsBody(rectangleOf: pipeTop.size)
        initializeStaticPhysicsBody(body: pipeTop.physicsBody, OBJECT_CONTACT_MASK)
        
        _scene.addChild(pipeBase)
        _scene.addChild(pipeTop)
    }
    
    /// Generates a random number from [0, 100) and returns true if it is less than cutoff
    func randLessThan(_ cutoff: Int) -> Bool {
        return Int.random(in: 0..<100) < cutoff
    }
    
    /// true if curX is within a quarter chunk of the position we've rendered up to
    func shouldRenderNextChunk(_ curX: CGFloat?) -> Bool {
        return (_renderedTo - (curX ?? 0)) < CHUNK_SIZE / 2
    }
}
