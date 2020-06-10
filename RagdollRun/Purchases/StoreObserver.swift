//
//  StoreObserver.swift
//  RagdollRun
//
//  Created by Jacob Leiken on 6/10/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import Foundation
import StoreKit

protocol StoreAlertDelegate: AnyObject {
    func present(_ alert: UIAlertController)
}

class StoreObserver: NSObject {
    
    static let shared = StoreObserver()
    
    /**
     Indicates whether the user is allowed to make payments.
     - returns: true if the user is allowed to make payments and false, otherwise. Tell StoreManager to query the App Store when the user is
     allowed to make payments and there are product identifiers to be queried.
     */
    var isAuthorizedForPayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    /// Keeps track of all purchases.
    var purchased = [SKPaymentTransaction]()
    
    /// Keeps track of all restored purchases.
    var restored = [SKPaymentTransaction]()
    
    /// Indicates whether there are restorable purchases.
    fileprivate var hasRestorablePurchases = false
    
    weak var delegate: StoreAlertDelegate?
        
    // MARK: - Initializer
    
    private override init() {}
    
    // MARK: - Submit Payment Request
    
    /// Create and add a payment request to the payment queue.
    func buy(_ product: SKProduct) {
        let payment = SKMutablePayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // MARK: - Restore All Restorable Purchases
    
    /// Restores all previously completed purchases.
    func restore() {
        if !restored.isEmpty {
            restored.removeAll()
        }
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - Handle Payment Transactions
    
    /// Handles successful purchase transactions.
    fileprivate func handlePurchased(_ transaction: SKPaymentTransaction) {
        purchased.append(transaction)
        let message = "\(Messages.deliverContent) \(transaction.payment.productIdentifier)."
        print(message)
        let alert = UIAlertController(title: "Purchase Completed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(Messages.okButton, comment: "Default action"), style: .default))
        self.delegate?.present(alert)
        registerPurchase(transaction)
        
        // Finish the successful transaction.
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    /// Handles failed purchase transactions.
    fileprivate func handleFailed(_ transaction: SKPaymentTransaction) {
        var message = "\(Messages.purchaseOf) \(transaction.payment.productIdentifier) \(Messages.failed)"
        
        if let error = transaction.error {
            message += "\n\(Messages.error) \(error.localizedDescription)"
            print("\(Messages.error) \(error.localizedDescription)")
        }
        
        // Do not send any notifications when the user cancels the purchase.
        if (transaction.error as? SKError)?.code != .paymentCancelled {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Payment Failed", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString(Messages.okButton, comment: "Default action"), style: .default))
                self.delegate?.present(alert)
            }
        }
        // Finish the failed transaction.
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    /// Handles restored purchase transactions.
    fileprivate func handleRestored(_ transaction: SKPaymentTransaction) {
        hasRestorablePurchases = true
        restored.append(transaction)
        let message = "\(Messages.restoreContent) \(transaction.payment.productIdentifier)."
        print(message)
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Purchases Restored", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString(Messages.okButton, comment: "Default action"), style: .default))
            self.delegate?.present(alert)
        }
        // Finishes the restored transaction.
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}

// MARK: - SKPaymentTransactionObserver

/// Extends StoreObserver to conform to SKPaymentTransactionObserver.
extension StoreObserver: SKPaymentTransactionObserver {
    /// Called when there are transactions in the payment queue.
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing: break
            // Do not block the UI. Allow the user to continue using the app.
            case .deferred: print(Messages.deferred)
            // The purchase was successful.
            case .purchased: handlePurchased(transaction)
            // The transaction failed.
            case .failed: handleFailed(transaction)
            // There're restored products.
            case .restored: handleRestored(transaction)
            @unknown default: fatalError(Messages.unknownPaymentTransaction)
            }
        }
    }
    
    /// Logs all transactions that have been removed from the payment queue.
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print("\(transaction.payment.productIdentifier) \(Messages.removed)")
        }
    }
    
    /// Called when an error occur while restoring purchases. Notify the user about the error.
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        if let error = error as? SKError, error.code != .paymentCancelled {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Payment Failed", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString(Messages.okButton, comment: "Default action"), style: .default))
                self.delegate?.present(alert)
            }
        }
    }
    
    /// Called when all restorable transactions have been processed by the payment queue.
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print(Messages.restorable)
        
        if !hasRestorablePurchases {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "No purchases to restore", message: Messages.noRestorablePurchases, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString(Messages.okButton, comment: "Default action"), style: .default))
                self.delegate?.present(alert)
            }
        }
    }
}
