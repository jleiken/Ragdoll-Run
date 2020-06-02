//
//  StyleApplicator.swift
//  RagdollRun
//
//  Created by Jacob Leiken on 6/1/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import SpriteKit

typealias StyleApplicator = (SKSpriteNode) -> ()

func colorToStyleAppArray(_ color: UIColor) -> [StyleApplicator] {
    var arr = [StyleApplicator]()
    let colorer: StyleApplicator = {node in node.color = color}
    for _ in 0..<6 {
        arr.append(colorer)
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

let STYLES: [String: [StyleApplicator]] = [
    "orange": colorToStyleAppArray(ORANGE),
    "red": colorToStyleAppArray(.red),
    "yellow": colorToStyleAppArray(.yellow),
    "black": colorToStyleAppArray(.black),
    "purple": colorToStyleAppArray(.purple),
    "steve": [],
    "solo": [],
]

var _selectedStyle: String = "orange"
var selectedStyle: String {
    get {
        return _selectedStyle
    }
    set {
        _selectedStyle = newValue
    }
}
