//
//  StyleManager.swift
//  RagdollRun
//
//  Created by Jacob Leiken on 6/1/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import SpriteKit

typealias StyleApplicator = (SKSpriteNode) -> ()

let NUM_STYLES: Int = 9

/// order of 6 element style applicator array must be torso, head, legL, legR, armL, armR
let STYLES: [String: [StyleApplicator]] = [
    "Orange": colorToStyleAppArray(Formats.HIGHLIGHT),
    "Green": colorToStyleAppArray(hexStringToUIColor(hex: "d6ffb7")),
    "Blue": colorToStyleAppArray(hexStringToUIColor(hex: "080357")),
    "Black": colorToStyleAppArray(.black),
    "White": colorToStyleAppArray(.white),
    "Purple": colorToStyleAppArray(hexStringToUIColor(hex: "63458a")),
    "Steve": characterToStyleAppArray("Steve"),
    "Chief": characterToStyleAppArray("Chief"),
    "Sherlock": characterToStyleAppArray("Sherlock"),
]

let STYLES_ORDERING: [String] = ["Orange", "Green", "Blue", "Black", "White", "Purple", "Steve", "Chief", "Sherlock"]

let STYLES_PRICES: [String: Int64] = [
    "Orange": 100,
    "Green": 100,
    "Blue": 100,
    "Black": 200,
    "White": 200,
    "Purple": 200,
    "Steve": 500,
    "Chief": 500,
    "Sherlock": 500,
]

func colorToStyleAppArray(_ color: UIColor) -> [StyleApplicator] {
    var arr = [StyleApplicator]()
    let colorer: StyleApplicator = {node in node.color = color}
    for _ in 0..<6 {
        arr.append(colorer)
    }
    
    return arr
}
 
/// creates a style applicator array from images of the names "\\(character)Torso", "\\(character)Head", and so on
func characterToStyleAppArray(_ character: String) -> [StyleApplicator] {
    var arr = [StyleApplicator]()
    let parts = ["Torso", "Head", "Leg", "Leg", "Arm", "Arm"].map({ character + $0 })
    for part in parts {
        arr.append({ $0.texture = SKTexture(imageNamed: part) })
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
            _selectedStyle = NSUbiquitousKeyValueStore.default.string(forKey: CloudKeys.STYLE_KEY)
            if _selectedStyle == nil {
                _selectedStyle = STYLES_ORDERING.first!
            } 
        }
        return _selectedStyle!
    }
    set {
        _selectedStyle = newValue
        NSUbiquitousKeyValueStore.default.set(_selectedStyle, forKey: CloudKeys.STYLE_KEY)
    }
}

var _unlockedStyles: [String] = [STYLES_ORDERING.first!]
var unlockedStyles: [String] {
    get {
        if let cloudStyles = NSUbiquitousKeyValueStore.default.array(forKey: CloudKeys.UNLOCKS_KEY) as? [String] {
            _unlockedStyles = cloudStyles
        }
        return _unlockedStyles
    }
    set {
        _unlockedStyles = newValue
        NSUbiquitousKeyValueStore.default.set(_unlockedStyles, forKey: CloudKeys.UNLOCKS_KEY)
    }
}
