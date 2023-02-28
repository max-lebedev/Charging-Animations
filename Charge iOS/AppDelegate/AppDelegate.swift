//
//  AppDelegate.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 23.12.2021.
//

import UIKit
import GoogleMobileAds
import SwiftyUserDefaults

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        // Subscription
        SubscriptionManager.instance.verifySubscriptionAtLaunch()
        checkPriceChange()
        
        // AdMob
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        InterstitialService.instance.needLoadAd()
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = Keys.testDeviceIdentifiers

        return true
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func checkPriceChange() {
        SubscriptionManager.instance.getProductInfo(productId: Keys.productIds[0]) { price in
            if Defaults.montlyPrice != price {
                Defaults.montlyPrice = price
            } else { return }
        }
        SubscriptionManager.instance.getProductInfo(productId: Keys.productIds[1]) { price in
            if Defaults.yearlyPrice != price {
                Defaults.yearlyPrice = price
            } else { return }
        }
    }
}

