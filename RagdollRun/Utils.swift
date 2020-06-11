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
func nodeIsWorld(node: SKNode) -> Bool {
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
func makeButton(scene: SKScene, text: String, name: String) -> SKNode {
    let textNode = makeLabel(text: text)
    textNode.name = name
    textNode.position = CGPoint(x: 0, y: 0)
    
    let textSize = NSString(string: text).size(withAttributes: [.font: UIFont(name: textNode.fontName!, size: textNode.fontSize)!])
    let buttonSize = CGSize(width: textSize.width + scene.size.width/20, height: textSize.height)
    let but = SKSpriteNode(color: .black, size: buttonSize)
    but.name = name
    but.addChild(textNode)
    
    return but
}

/// makes a label with the given text
func makeLabel(text: String) -> SKLabelNode {
    let textNode = SKLabelNode(text: text)
    textNode.verticalAlignmentMode = .center
    textNode.horizontalAlignmentMode = .center
    textNode.fontColor = .white
    textNode.fontName = Formats.LABEL_FONT
    
    return textNode
}

/// from https://stackoverflow.com/questions/24263007/how-to-use-hex-color-values
func hexStringToUIColor(hex: String) -> UIColor {
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
