//
//  CloudGenerator.swift
//  RagdollRun
//
//  Created by Jacob Leiken on 12/27/21.
//  Copyright © 2021 Jacob Leiken. All rights reserved.
//

import SpriteKit
import GameplayKit

/// Generates cloud sprites
class CloudGenerator {

    private let _cloudHeightGenerator: GKGaussianDistribution
    private let _scene: SKScene
    
    init(scene: SKScene, groundHeight: CGFloat) {
        _scene = scene
        _cloudHeightGenerator = GKGaussianDistribution(randomSource: GKRandomSource(),
                                                       lowestValue: Int(groundHeight),
                                                       highestValue: Int(_scene.size.height/2))
    }

    /// Generates a cloud with shadow scaled to `scene` at `position`
    func generateCloud(xPosition: CGFloat, scale: CGFloat? = nil) -> SKSpriteNode {
        // pick a type of cloud
        let cloudType = Int.random(in: 1...3)
        
        let cloudFileName = "Cloud\(cloudType)"
        
        // add the cloud at a low z index
        let cloud = cloudFrom(fileNamed: cloudFileName)
        cloud.position = CGPoint(x: xPosition, y: CGFloat(_cloudHeightGenerator.nextInt()))
        cloud.zPosition = -CGFloat(cloudType)
        
        // add the cloud shadow
        let cloudShadow = cloud.copy() as! SKSpriteNode
        cloudShadow.position = CGPoint(x: 4, y: -2.5)
        cloudShadow.zPosition -= 1
        cloudShadow.color = Formats.SHADOW_COLOR
        cloudShadow.alpha = Formats.SHADOW_ALPHA
        
        cloud.addChild(cloudShadow)
        return cloud
    }

    /// Creates a cloud sprite (with shadow) in the shape of `fileNamed` scaled to `scene`
    private func cloudFrom(fileNamed: String, scale: CGFloat = CGFloat.random(in: 0.06...0.12)) -> SKSpriteNode {
        let cloud = SKSpriteNode(imageNamed: fileNamed)
        cloud.size = sizeByScene(_scene, xFactor: scale, yFactor: scale)
        return cloud
    }
    
}
