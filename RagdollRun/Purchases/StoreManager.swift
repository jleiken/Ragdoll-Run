//
//  StoreManager.swift
//  RagdollRun
//
//  Created by Jacob Leiken on 6/10/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import StoreKit
import Foundation

class StoreManager: NSObject {
    // MARK: - Types
    
    static let shared = StoreManager()
    
    // MARK: - Properties
    
    /// Keeps track of all valid products. These products are available for sale in the App Store.
    fileprivate var availableProducts = [SKProduct]()
    
    /// Keeps a strong reference to the product request.
    fileprivate var productRequest: SKProductsRequest!
    
    weak var delegate: StoreAlertDelegate?
    
    // MARK: - Initializer
    
    private override init() {}
    
    // MARK: - Request Product Information
    
    /// Starts the product request with the specified identifiers.
    func startProductRequest() {
        fetchProducts(matchingIdentifiers: ["coins100", "coins500", "coins2000", "remove_ads"])
    }
    
    /// Fetches information about your products from the App Store.
    /// - Tag: FetchProductInformation
    fileprivate func fetchProducts(matchingIdentifiers identifiers: [String]) {
        // Create a set for the product identifiers.
        let productIdentifiers = Set(identifiers)
        
        // Initialize the product request with the above identifiers.
        productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        
        // Send the request to the App Store.
        productRequest.start()
    }
    
    // MARK: - Helper Methods
    func paymentRequest(matchingIdentifier identifier: String) {
        guard !availableProducts.isEmpty else { return }
        
        // Search availableProducts for a product whose productIdentifier property matches identifier
        let result = availableProducts.filter({ (product: SKProduct) in product.productIdentifier == identifier })
        
        if !result.isEmpty {
            StoreObserver.shared.buy(result.first!)
        }
    }
    
    /// - returns: Existing product's price matching the specified product identifier.
    func price(matchingIdentifier identifier: String) -> NSDecimalNumber? {
        var price: NSDecimalNumber?
        guard !availableProducts.isEmpty else { return nil }
        
        // Search availableProducts for a product whose productIdentifier property matches identifier. Return its localized title when found.
        let result = availableProducts.filter({ (product: SKProduct) in product.productIdentifier == identifier })
        
        if !result.isEmpty {
            price = result.first!.price
        }
        return price
    }
    
    /// - returns: Existing product's price matching the specified product identifier.
    func title(matchingIdentifier identifier: String) -> String? {
        var title: String?
        guard !availableProducts.isEmpty else { return nil }
        
        // Search availableProducts for a product whose productIdentifier property matches identifier. Return its localized title when found.
        let result = availableProducts.filter({ (product: SKProduct) in product.productIdentifier == identifier })
        
        if !result.isEmpty {
            title = result.first!.localizedTitle
        }
        return title
    }
    
    /// - returns: Existing product's title associated with the specified payment transaction.
    func title(matchingPaymentTransaction transaction: SKPaymentTransaction) -> String {
        let title = self.title(matchingIdentifier: transaction.payment.productIdentifier)
        return title ?? transaction.payment.productIdentifier
    }
}

// MARK: - SKProductsRequestDelegate

/// Extends StoreManager to conform to SKProductsRequestDelegate.
extension StoreManager: SKProductsRequestDelegate {
    /// Used to get the App Store's response to your request and notify your observer.
    /// - Tag: ProductRequest
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        // products contains products whose identifiers have been recognized by the App Store. As such, they can be purchased.
        if !response.products.isEmpty {
            availableProducts = response.products
        }
    }
}

// MARK: - SKRequestDelegate

/// Extends StoreManager to conform to SKRequestDelegate.
extension StoreManager: SKRequestDelegate {
    /// Called when the product request failed.
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async {
            print(error)
        }
    }
}

