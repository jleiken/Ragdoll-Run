//
//  StyleManager.swift
//  RagdollRun
//
//  Created by Jacob Leiken on 6/1/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import SpriteKit

typealias StyleApplicator = (SKSpriteNode) -> ()

let NUM_STYLES: Int = 6

/// order of 6 element style applicator array must be torso, head, legL, legR, armL, armR
let STYLES: [String: [StyleApplicator]] = [
    "Orange": colorToStyleAppArray(ORANGE),
    "Red": colorToStyleAppArray(.red),
    "Yellow": colorToStyleAppArray(.yellow),
    "Black": colorToStyleAppArray(.black),
    "Purple": colorToStyleAppArray(.purple),
    "Steve": texturesToStyleAppArray([
                SKTexture(imageNamed: "SteveTorso"), SKTexture(imageNamed: "SteveHead"),
                SKTexture(imageNamed: "SteveLeg"), SKTexture(imageNamed: "SteveLeg"),
                SKTexture(imageNamed: "SteveArm"), SKTexture(imageNamed: "SteveArm")]),
]

let STYLES_ORDERING: [String] = ["Orange", "Red", "Yellow", "Black", "Purple", "Steve"]

let STYLES_PRICES: [String: Int64] = [
    "Orange": 100,
    "Red": 100,
    "Yellow": 100,
    "Black": 100,
    "Purple": 100,
    "Steve": 500,
]

func colorToStyleAppArray(_ color: UIColor) -> [StyleApplicator] {
    var arr = [StyleApplicator]()
    let colorer: StyleApplicator = {node in node.color = color}
    for _ in 0..<6 {
        arr.append(colorer)
    }
    
    return arr
}

func texturesToStyleAppArray(_ textures: [SKTexture]) -> [StyleApplicator] {
    var arr = [StyleApplicator]()
    for texture in textures {
        arr.append({ $0.texture = texture })
    }
    
    return arr
}

func applySelectedStyles(nodes: [SKSpriteNode]) {
    if selectedStyle.count != nodes.count {
        print("node and style count mismatch, exiting")
        return
    }
    
    for i in 0..<nodes.count {
        STYLES[selectedStyle]![i](nodes[i])
    }
}

var _selectedStyle: String?
var selectedStyle: String {
    get {
        if _selectedStyle == nil {
            _selectedStyle = NSUbiquitousKeyValueStore.default.string(forKey: STYLE_KEY)
            if _selectedStyle == nil {
                _selectedStyle = STYLES_ORDERING.first!
            } 
        }
        return _selectedStyle!
    }
    set {
        _selectedStyle = newValue
        NSUbiquitousKeyValueStore.default.set(_selectedStyle, forKey: STYLE_KEY)
    }
}

var _unlockedStyles: [String] = [STYLES_ORDERING.first!]
var unlockedStyles: [String] {
    get {
        if let cloudStyles = NSUbiquitousKeyValueStore.default.array(forKey: UNLOCKS_KEY) as? [String] {
            _unlockedStyles = cloudStyles
        }
        return _unlockedStyles
    }
    set {
        _unlockedStyles = newValue
        NSUbiquitousKeyValueStore.default.set(_unlockedStyles, forKey: UNLOCKS_KEY)
    }
}
