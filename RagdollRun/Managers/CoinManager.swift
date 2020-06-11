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

func registerPurchase(_ transaction: SKPaymentTransaction) {
    let productID = transaction.payment.productIdentifier
    let state = transaction.transactionState
    if state == .purchased && COIN_IDS.contains(productID) {
        // the number is after the word "coins"
        if let index = productID.lastIndex(of: "s") {
            if let value = Int64(productID.suffix(from: productID.index(after: index))) {
                CloudVars.coinCount += value
            }
        }
    } else if (state == .purchased || state == .restored) && productID == SpriteNames.REMOVE_AD_NAME {
        // the user has purchased the remove ad option, store that value
        CloudVars.hideAds = true
        // TODO: actually hide any ads that might be showing
    }
}
