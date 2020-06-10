//
//  CoinManager.swift
//  RagdollRun
//
//  Created by Jacob Leiken on 6/10/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import Foundation
import StoreKit

let COIN_OPTIONS = [100, 500, 2000]
let COIN_IDS = ["coins100", "coins500", "coins2000"]

var _coinCount: Int64 = -1
var coinCount: Int64 {
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

func registerPurchase(_ transaction: SKPaymentTransaction) {
    let productID = transaction.payment.productIdentifier
    if transaction.transactionState == .purchased && COIN_IDS.contains(productID) {
        // the number is after the word "coins"
        if let index = productID.lastIndex(of: "s") {
            if let value = Int64(productID.suffix(from: productID.index(after: index))) {
                coinCount += value
            }
        }
    }
}
