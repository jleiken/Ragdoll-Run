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
    if (STYLES[CloudVars.selectedStyle]?.count ?? -1) != nodes.count {
        print("node and style count mismatch, exiting")
        return
    }
    
    for i in 0..<nodes.count {
        STYLES[CloudVars.selectedStyle]![i](nodes[i])
    }
}
