//
//  Match.swift
//  Ragdoll Run
//
//  Created by Jacob Leiken on 6/4/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import Foundation
import Messages

struct Outcome {
    var participant: UUID
    var score: Int
}

/// `URLQueryItem` extension for Outcome
extension Outcome {
    var queryItem: URLQueryItem{
        return URLQueryItem(name: participant.uuidString, value: "\(score)")
    }
    
    init?(_ queryItem: URLQueryItem) {
        guard let participant = UUID(uuidString: queryItem.name) else { return nil }
        guard let score = Int(queryItem.value!) else { return nil }
        
        self.participant = participant
        self.score = score
    }
}

struct RunMatch {
    var particpantScores: [Outcome]
    var active: Bool
    
    let activeKey = "active"
}

/// `URLQueryItem` extension for RunMatch
extension RunMatch {
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
    
        for outcome in particpantScores {
            items.append(outcome.queryItem)
        }
        items.append(URLQueryItem(name: self.activeKey, value: "\(active)"))
        
        return items
    }
    
    init?(queryItems: [URLQueryItem]) {
        self.particpantScores = []
        var active = false
        
        for queryItem in queryItems {
            if let decodedOutcome = Outcome(queryItem) {
                self.particpantScores.append(decodedOutcome)
            } else if queryItem.name == self.activeKey {
                guard let newActive = Bool(queryItem.value!) else { fatalError("Invalid Query Item for active key: \(String(describing: queryItem.value))") }
                active = newActive
            }
        }
        
        self.active = active
    }
}

/// Extension to create RunMatch from an `MSMessage`
extension RunMatch {
    init?(message: MSMessage?) {
        guard let messageURL = message?.url else { return nil }
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false) else { return nil }
        guard let queryItems = urlComponents.queryItems else { return nil }
        self.init(queryItems: queryItems)
    }
}
