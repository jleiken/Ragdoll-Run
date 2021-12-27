//
//  Utils.swift
//  RegularMaria
//
//  Created by Jacob Leiken on 5/14/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import SpriteKit

/// initializes characteristics of a static physics body (no bounce or movement)
func initializeStaticPhysicsBody(body cBody: SKPhysicsBody?) {
    if let body = cBody {
        body.restitution = 0.0
        body.isDynamic = false
    }
}

/// returns true if the node is part of the "world", that is ground, obstacle, or enemy, rather than avatar or camera
func nodeIsWorld(_ node: SKNode) -> Bool {
    return node.name == SpriteNames.GROUND_NAME
        || node.name == SpriteNames.OBSTACLE_NAME
        || node.name == SpriteNames.ENEMY_NAME
}

/// generates a CGSize that is a factor the scene's size, scaled by xFactor and yFactor
func sizeByScene(_ scene: SKScene, xFactor: CGFloat, yFactor: CGFloat) -> CGSize {
    let w = (scene.size.width + scene.size.height) * xFactor
    let h = (scene.size.width + scene.size.height) * yFactor
    
    return CGSize(width: w, height: h)
}

/// makes a button based on the given scene
func makeScaledTextButton(scene: SKScene, text: String, name: String) -> SKNode {
    let textNode = makeLabel(text)
    textNode.name = name
    textNode.position = CGPoint.zero
    
    let textSize = NSString(string: text).size(withAttributes: [.font: UIFont(name: textNode.fontName!, size: textNode.fontSize)!])
    let buttonSize = CGSize(width: textSize.width + scene.size.width/20, height: textSize.height)
    
    let buttonPath = CGPath(
        roundedRect: CGRect(origin: CGPoint.zero, size: buttonSize),
        cornerWidth: 7,
        cornerHeight: 7,
        transform: nil)
    let but = SKShapeNode(path: buttonPath, centered: true)
    
    but.fillColor = .black
    but.strokeColor = .black
    but.name = name
    but.addChild(textNode)
    
    return but
}

/// makes a label with the given text
func makeLabel(_ text: String) -> SKLabelNode {
    let textNode = SKLabelNode(text: text)
    textNode.verticalAlignmentMode = .center
    textNode.horizontalAlignmentMode = .center
    textNode.fontColor = .white
    textNode.fontName = Formats.LABEL_FONT
    
    return textNode
}

/// Adds moving clouds to the background `scene`
func addMenuClouds(_ scene: SKScene) {
    let topOrBottom = scene.size.height/2
    let leftOrRight = scene.size.width/2
    let totalAllowableDuration = 30.0
    let cloudGenerator = CloudGenerator(scene: scene, groundHeight: -topOrBottom)
    
    for _ in 0...6 {
        let cloud = cloudGenerator.generateCloud(xPosition: CGFloat.random(in: -leftOrRight...leftOrRight))
        let inverseCloudScale = 1-(cloud.size.width/(scene.size.width+scene.size.height))
        let cloudsDuration = totalAllowableDuration * inverseCloudScale
        let cloudOffScreen = leftOrRight+(cloud.size.width/2)
        let distFromLeftPercentage = abs((cloud.position.x+leftOrRight)/scene.size.width)
        cloud.run(SKAction.sequence([
            SKAction.moveTo(x: -cloudOffScreen, duration: cloudsDuration*distFromLeftPercentage),
            SKAction.repeatForever(SKAction.sequence([
                SKAction.moveTo(x: cloudOffScreen, duration: 0),
                SKAction.moveTo(x: -cloudOffScreen, duration: cloudsDuration)
            ]))
        ]))
        scene.addChild(cloud)
    }
}

/// from https://stackoverflow.com/questions/24263007/how-to-use-hex-color-values
func hexStringToUIColor(_ hex: String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func playSound(node: SKNode, fileNamed file: String) {
    if !CloudVars.muted {
        node.run(SKAction.playSoundFileNamed(file, waitForCompletion: false))
    }
}

/// Generates a random number from [0, 100) and returns true if it is less than cutoff
func randLessThan(_ cutoff: Int) -> Bool {
    return Int.random(in: 0..<100) < cutoff
}
