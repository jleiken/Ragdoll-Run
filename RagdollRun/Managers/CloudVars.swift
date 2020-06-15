//
//  CloudVars.swift
//  RagdollRun
//
//  Created by Jacob Leiken on 6/11/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import Foundation

struct CloudKeys {
    static let SCORE_KEY = "highScore"
    static let COIN_KEY = "coinCount"
    static let STYLE_KEY = "selectedStyle"
    static let UNLOCKS_KEY = "unlockedStyles"
    static let AD_KEY = "hideAds"
    static let MUTE_KEY = "muted"
}

/// Manages all cloud variables
class CloudVars {
    
    /// Can't be instantiated
    fileprivate init() {}
    
    static private var _muted: Bool = false
    /// Indicates if the user has muted the game or not
    static var muted: Bool {
        get {
            if !_muted {
                _muted = NSUbiquitousKeyValueStore.default.bool(forKey: CloudKeys.MUTE_KEY)
            }
            return _muted
        }
        set {
            _muted = newValue
            NSUbiquitousKeyValueStore.default.set(newValue, forKey: CloudKeys.MUTE_KEY)
        }
    }
    
    static private var _selectedStyle: String?
    /// The user-selected character style
    static var selectedStyle: String {
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

    static private var _unlockedStyles: [String] = [STYLES_ORDERING.first!]
    /// The array of styles the user has unlocked so far. Default contains HIGHLIGHT color
    static var unlockedStyles: [String] {
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
    
    static private var _coinCount: Int64 = -1
    /// The number of coins a user has collected and/or purchased
    static var coinCount: Int64 {
        /// checks with CloudKit if the coin count has been pulled or set yet
        get {
            if _coinCount == -1 {
                // may not exist, but default is 0 anyway
                _coinCount = NSUbiquitousKeyValueStore.default.longLong(forKey: CloudKeys.COIN_KEY)
            }
            return _coinCount
        }
        /// sets in CloudKit and locally
        set {
            _coinCount = newValue
            NSUbiquitousKeyValueStore.default.set(newValue, forKey: CloudKeys.COIN_KEY)
        }
    }

    static private var _hideAds: Bool = false
    /// True if the user has paid to hide ads, false otherwise
    static var hideAds: Bool {
        get {
            // if we're the default value, just check to make sure they haven't purchased ad-free
            if !_hideAds {
                _hideAds = NSUbiquitousKeyValueStore.default.bool(forKey: CloudKeys.AD_KEY)
            }
            return _hideAds
        }
        set {
            _hideAds = newValue
            NSUbiquitousKeyValueStore.default.set(newValue, forKey: CloudKeys.AD_KEY)
        }
    }
    
    private static var _highScore: Int64 = -1
    /// The player's high score
    static var highScore: Int64 {
        /// checks with CloudKit if highScore has been pulled or set yet
        get {
            if _highScore == -1 {
                // may not exist, but default is 0 anyway
                _highScore = NSUbiquitousKeyValueStore.default.longLong(forKey: CloudKeys.SCORE_KEY)
            }
            return _highScore
        }
        /// sets in CloudKit and locally
        set {
            _highScore = newValue
            NSUbiquitousKeyValueStore.default.set(newValue, forKey: CloudKeys.SCORE_KEY)
        }
    }
    
    static func storeDidChange(forKey: String) {
        switch forKey {
        case CloudKeys.SCORE_KEY:
            _highScore = NSUbiquitousKeyValueStore.default.longLong(forKey: forKey)
        case CloudKeys.COIN_KEY:
            _coinCount = NSUbiquitousKeyValueStore.default.longLong(forKey: forKey)
        case CloudKeys.STYLE_KEY:
            _selectedStyle = NSUbiquitousKeyValueStore.default.string(forKey: forKey)
        case CloudKeys.UNLOCKS_KEY:
            if let newValue = NSUbiquitousKeyValueStore.default.array(forKey: forKey) as? [String] {
                _unlockedStyles = newValue
            }
        case CloudKeys.AD_KEY:
            _hideAds = NSUbiquitousKeyValueStore.default.bool(forKey: forKey)
        case CloudKeys.MUTE_KEY:
            _muted = NSUbiquitousKeyValueStore.default.bool(forKey: forKey)
        default:
            return
        }
    }

}
