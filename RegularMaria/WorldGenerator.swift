//
//  WorldGenerator.swift
//  RegularMaria
//
//  Created by Jacob Leiken on 5/20/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import SpriteKit

let CHUNK_SIZE = CGFloat(5000)

class WorldGenerator {
    private var _renderedTo : CGFloat
    private var _groundHeight : CGFloat
    private var _scene : SKScene
    
    private var ENEMY_FREQ = CGFloat(100)
    private var PIPE_FREQ = CGFloat(150)
    
    init(groundHeight : CGFloat, startingPos : CGFloat, scene : SKScene) {
        _renderedTo = startingPos
        _groundHeight = groundHeight
        _scene = scene
    }
    
    func renderChunk(size: CGFloat) {
        let from = _renderedTo
        let to = _renderedTo + size
        print("from \(from) to \(to)")
        
        generateGroundWithHoles(from, to)
        generateEnemies(from, to)
        generatePipes(from, to)
        
        _renderedTo = to
    }
    
    /// Generate ground from renderedTo to renderedTo + size with holes
    func generateGroundWithHoles(_ from: CGFloat, _ to: CGFloat) {
        var groundPoints = [CGPoint(x: from, y: _groundHeight),
                            CGPoint(x: to, y: _groundHeight)]
        let ground = SKShapeNode(points: &groundPoints, count: groundPoints.count)
        ground.name = GROUND_NAME
        ground.lineWidth = 5
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        initializeStaticPhysicsBody(body: ground.physicsBody, GROUND_CONTACT_MASK)
        _scene.addChild(ground)
    }

    /// Generate enemies from renderedTo to renderedTo + size based on ENEMY_FREQ
    func generateEnemies(_ from: CGFloat, _ to: CGFloat) {
        
    }
    
    /// Generate pipes from renderedTo to renderedTo + size based on PIPE_FREQ
    func generatePipes(_ from: CGFloat, _ to: CGFloat) {
        
    }
    
    func shouldRenderNextChunk(_ curX: CGFloat?) -> Bool {
        return (_renderedTo - (curX ?? 0)) < CHUNK_SIZE / 2
    }
}
