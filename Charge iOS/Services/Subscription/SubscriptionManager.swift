//
//  SubscriptionManager.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 17.02.2022.
//

import Foundation
import SwiftyStoreKit
import SwiftyUserDefaults

class SubscriptionManager {
    static let instance = SubscriptionManager()
    var prices = [String](repeating: "", count: 2)

    private init() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
        }
    }

    func loadPriceData(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        for (index, productId) in Keys.productIds.enumerated() {
            dispatchGroup.enter()
            getProductInfo(productId: productId) { price in
                DispatchQueue.global().sync {
                    self.prices[index] = price
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }

    func getProductInfo(productId: String, completion: @escaping (String) -> Void) {
        var price = String()
        SwiftyStoreKit.retrieveProductsInfo([productId]) { result in
            if let product = result.retrievedProducts.first {
                guard let priceString = product.localizedPrice else { return }
                print("Product: \(product.localizedDescription), price: \(String(describing: priceString))")
                price = priceString
                completion(price)
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            } else {
                print("Error: \(String(describing: result.error))")
            }
        }
    }
 
    public func purchaseMonthlySubscription(completion: @escaping (Bool) -> Void) {
        // swiftlint:disable all
        let purchased = true
        SwiftyStoreKit.purchaseProduct(Keys.productIds[0], quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                Defaults.subscribtionPurchased = true
                InterstitialService.instance.deloadAd()
                completion(purchased)
            case .error(let error):
                switch error.code {
                case .unknown:
                    print("Unknown error. Please contact support")
                case .clientInvalid:
                    print("Not allowed to make the payment")
                case .paymentCancelled:
                    break
                case .paymentInvalid:
                    print("The purchase identifier was invalid")
                case .paymentNotAllowed:
                    print("The device is not allowed to make the payment")
                case .storeProductNotAvailable:
                    print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied:
                    print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed:
                    print("Could not connect to the network")
                case .cloudServiceRevoked:
                    print("User has revoked permission to use this cloud service")
                default:
                    print((error as NSError).localizedDescription)
                }
                completion(false)
            case .deferred(purchase: let purchase):
                return
            }
        }
    }

    public func purchaseYearlySubscription(completion: @escaping (Bool) -> Void) {
        let purchased = true
        // swiftlint:disable all
        SwiftyStoreKit.purchaseProduct(Keys.productIds[1], quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                Defaults.subscribtionPurchased = true
                InterstitialService.instance.deloadAd()
                completion(purchased)
            case .error(let error):
                switch error.code {
                case .unknown:
                    print("Unknown error. Please contact support")
                case .clientInvalid:
                    print("Not allowed to make the payment")
                case .paymentCancelled:
                    break
                case .paymentInvalid:
                    print("The purchase identifier was invalid")
                case .paymentNotAllowed:
                    print("The device is not allowed to make the payment")
                case .storeProductNotAvailable:
                    print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied:
                    print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed:
                    print("Could not connect to the network")
                case .cloudServiceRevoked:
                    print("User has revoked permission to use this cloud service")
                default:
                    print((error as NSError).localizedDescription)
                }
                completion(false)
            case .deferred(purchase: let purchase):
                return
            }
        }
    }

    func restorePurchases(completion: @escaping (Bool) -> Void) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                completion(false)
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                Defaults.subscribtionPurchased = true
                InterstitialService.instance.deloadAd()
                completion(true)
            }
            else {
                print("Nothing to Restore")
                completion(false)
            }
        }
    }

    private func verifySubscription(productId: String) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: Keys.sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                // Verify the purchase of a Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable, // or .nonRenewing (see below)
                    productId: productId,
                    inReceipt: receipt)
                    
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
                    Defaults.subscribtionPurchased = true
                    InterstitialService.instance.deloadAd()
                case .expired(let expiryDate, let items):
                    print("\(productId) is expired since \(expiryDate)\n\(items)\n")
                    Defaults.subscribtionPurchased = false
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                    Defaults.subscribtionPurchased = false
                }

            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }

    func verifySubscriptionAtLaunch() {
        for productId in Keys.productIds {
           verifySubscription(productId: productId)
        }
    }
}
