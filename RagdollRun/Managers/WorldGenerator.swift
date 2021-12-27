//
//  WorldGenerator.swift
//  RegularMaria
//
//  Created by Jacob Leiken on 5/20/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import SpriteKit
import GameplayKit

class WorldGenerator {
    static let CHUNK_SIZE = CGFloat(7500)
    
    static let GROUND_COLOR = hexStringToUIColor(hex: "645244")
    static let ENEMY_COLOR = hexStringToUIColor(hex: "fe5f55")
    static let PIPE_COLOR = hexStringToUIColor(hex: "157f1f")
    
    private var _renderedTo: CGFloat
    private var _firstRender: Bool = true
    private var _groundHeight: CGFloat
    private var _scene: SKScene
    
    private var ENEMY_FREQ = 20
    private var PIPE_FREQ = 15
    private var COIN_FREQ = 20
    private var CLOUD_FREQ = 30
    /// the percantage likeliness that a hole is generated at each tick, out of 100
    private var HOLE_FREQ = 5
    private let HOLE_SIZE: CGFloat
    
    private let _cloudGenerator: CloudGenerator
    private let _enemyMovementSequence: SKAction
    private let _coinMovementSequence: SKAction
    
    init(groundHeight: CGFloat, startingPos: CGFloat, scene: SKScene) {
        _renderedTo = startingPos
        _groundHeight = groundHeight
        HOLE_SIZE = abs(_groundHeight / 1.4)
        _scene = scene
        _cloudGenerator = CloudGenerator(scene: scene, groundHeight: groundHeight)
        
        _enemyMovementSequence = SKAction.repeatForever(SKAction.sequence([
            SKAction.moveBy(x: _scene.size.width * 0.4, y: 0, duration: 0.4),
            SKAction.wait(forDuration: 0.1),
            SKAction.moveBy(x: -_scene.size.width * 0.4, y: 0, duration: 0.4),
            SKAction.wait(forDuration: 0.1),
        ]))
        _coinMovementSequence = SKAction.repeatForever(SKAction.sequence([
            SKAction.moveBy(x: _scene.size.height * 0.1, y: 0, duration: 0.2),
            SKAction.wait(forDuration: 0.1),
            SKAction.moveBy(x: -_scene.size.height * 0.1, y: 0, duration: 0.2),
            SKAction.wait(forDuration: 0.1),
        ]))
    }
    
    func renderChunk(size: CGFloat) {
        var from = _renderedTo
        let to = _renderedTo + size
        print("rendering from \(from) to \(to)")
        
        deleteOldChunk()
        
        generateGroundWithHoles(from, to)
        generateClouds(from, to)
        
        if _firstRender {
            // if it's our first render, don't let obstacles be generated too early
            from = _scene.size.width
            _firstRender = false
        }
        generateDangers(from, to)
        generateCoins(from, to)
        
        _renderedTo = to
    }
    
    /// Deletes everything a chunk behind the camera's position
    private func deleteOldChunk() {
        let deleteBefore = (_scene.camera?.position.x ?? WorldGenerator.CHUNK_SIZE) - WorldGenerator.CHUNK_SIZE
        for child in _scene.children {
            if nodeIsWorld(node: child) && child.position.x < deleteBefore {
                child.removeFromParent()
            }
        }
    }
    
    /// Generate ground from-to with holes placed at HOLE_FREQ%
    private func generateGroundWithHoles(_ from: CGFloat, _ to: CGFloat) {
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
                // if it's the first render don't put a hole right at the beginning
                if !(_firstRender && i < Int(_scene.size.width)) {
                    // if the current chunk should be a hole, mark that it was and continue
                    prevWasHole = true
                    continue
                }
            }
            
            // if it shouldn't be a whole, make a rectangle for the ground
            let ground = SKSpriteNode(color: WorldGenerator.GROUND_COLOR, size: CGSize(width: HOLE_SIZE+2, height: abs(_groundHeight)))
            // position is x: nextStart, y: bottom of the screen
            ground.position = CGPoint(x: CGFloat(i) * HOLE_SIZE, y: _groundHeight * 1.5)
            ground.name = SpriteNames.GROUND_NAME
            ground.zPosition = Physics.WORLD_Z
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            initializeStaticPhysicsBody(body: ground.physicsBody)
            _scene.addChild(ground)
        }
    }
    
    private func generateClouds(_ from: CGFloat, _ to: CGFloat) {
        var index = from
        let toIncrement = HOLE_SIZE/4
        
        while index < to {
            if randLessThan(CLOUD_FREQ) {
                let cloud = _cloudGenerator.generateCloud(xPosition: index)
                _scene.addChild(cloud)
            }
            
            index += toIncrement
        }
    }

    /// Once the ground is generated, generate enemies and obstacles from-to based on ENEMY_FREQ and PIPE_FREQ
    private func generateDangers(_ from: CGFloat, _ to: CGFloat) {
        var index = from
        while index < to {
            var toIncrement = HOLE_SIZE
            if _scene.atPoint(CGPoint(x: index, y: _groundHeight-5)).name == SpriteNames.GROUND_NAME {
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
    
    private func generateCoins(_ from: CGFloat, _ to: CGFloat) {
        var index = from
        while index < to {
            var toIncrement = HOLE_SIZE
            if _scene.atPoint(CGPoint(x: index, y: _groundHeight-5)).name == SpriteNames.GROUND_NAME {
                // there's ground here, so think about adding a coin if there's no pipe or enemy
                if _scene.atPoint(CGPoint(x: index, y: _groundHeight+5)).name == nil {
                    let genCoin = randLessThan(COIN_FREQ)
                    
                    if genCoin {
                        addCoin(x: index)
                        toIncrement = HOLE_SIZE/2
                    }
                }
            }
            
            index += toIncrement
        }
    }
    
    private func addEnemy(x: CGFloat) {
        let xSize = _scene.size.width * 0.1
        let ySize = _scene.size.height * 0.1
        var enemyPoints = [
            CGPoint(x: x+xSize, y: _groundHeight+ySize),
            CGPoint(x: x, y: _groundHeight),
            CGPoint(x: x+(xSize*3), y: _groundHeight),
            CGPoint(x: x+(xSize*2), y: _groundHeight+ySize),
        ]
        let enemy = SKShapeNode(points: &enemyPoints, count: enemyPoints.count)
        enemy.name = SpriteNames.ENEMY_NAME
        enemy.fillColor = WorldGenerator.ENEMY_COLOR
        enemy.lineWidth = 0.0
        enemy.zPosition = Physics.WORLD_Z
        enemy.physicsBody = SKPhysicsBody(polygonFrom: enemy.path!)
        initializeStaticPhysicsBody(body: enemy.physicsBody)
        
        // add enemy movement
        enemy.run(_enemyMovementSequence)
        _scene.addChild(enemy)
    }
    
    private func addPipe(x: CGFloat) {
        let pipeBase = SKSpriteNode(color: WorldGenerator.PIPE_COLOR, size: sizeByScene(_scene, xFactor: 0.05, yFactor: 0.12))
        pipeBase.name = SpriteNames.OBSTACLE_NAME
        pipeBase.position = CGPoint(x: x, y: _groundHeight+pipeBase.size.height/2)
        pipeBase.zPosition = Physics.WORLD_Z
        pipeBase.physicsBody = SKPhysicsBody(rectangleOf: pipeBase.size)
        initializeStaticPhysicsBody(body: pipeBase.physicsBody)
        
        let pipeTop = SKSpriteNode(color: WorldGenerator.PIPE_COLOR, size: sizeByScene(_scene, xFactor: 0.06, yFactor: 0.03))
        pipeTop.name = SpriteNames.OBSTACLE_NAME
        pipeTop.position = CGPoint(x: x, y: pipeBase.position.y+pipeBase.size.height/2)
        pipeTop.zPosition = Physics.WORLD_Z
        pipeTop.physicsBody = SKPhysicsBody(rectangleOf: pipeTop.size)
        initializeStaticPhysicsBody(body: pipeTop.physicsBody)
        
        _scene.addChild(pipeBase)
        _scene.addChild(pipeTop)
    }
    
    private func addCoin(x: CGFloat) {
        let squareSize = sizeByScene(_scene, xFactor: 0.02, yFactor: 0.02)
        let coin = SKShapeNode(circleOfRadius: squareSize.width)
        coin.fillColor = Formats.HIGHLIGHT
        coin.strokeColor = .black
        let dLabel = SKLabelNode(text: "💰")
        dLabel.horizontalAlignmentMode = .center
        dLabel.verticalAlignmentMode = .center
        dLabel.position = .zero
        coin.addChild(dLabel)
        
        let coinH = Int(squareSize.height)
        coin.position = CGPoint(x: x, y: _groundHeight + CGFloat(Int.random(in: coinH*2...coinH*20)))
        coin.zPosition = Physics.WORLD_Z
        coin.physicsBody = SKPhysicsBody(circleOfRadius: squareSize.width)
        coin.physicsBody?.isDynamic = false
        coin.physicsBody?.categoryBitMask = 0
        coin.physicsBody?.collisionBitMask = 0
        coin.physicsBody?.contactTestBitMask = Physics.COIN_CONTACT_MASK
        
        _scene.addChild(coin)
    }
    
    /// true if curX is within a quarter chunk of the position we've rendered up to
    func shouldRenderNextChunk(_ curX: CGFloat?) -> Bool {
        return (_renderedTo - (curX ?? 0)) < WorldGenerator.CHUNK_SIZE / 2
    }
}
