//
//  InterstitialManager.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 14.02.2022.
//

import Foundation
import SwiftyUserDefaults
import GoogleMobileAds

class InterstitialService: NSObject {

    static let instance = InterstitialService()
    var interstitial: GADInterstitialAd?

    func needLoadAd() {
        if !Defaults.subscribtionPurchased {
            createAndLoadInterstitial()
        }
    }
    
    func deloadAd() {
        interstitial = nil
    }

    private func createAndLoadInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: Keys.mainInterstitialId,
                               request: request,
                               completionHandler: { [self] ad, error in
                                if let error = error {
                                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                    return
                                }
                                interstitial = ad
                                interstitial?.fullScreenContentDelegate = self
                               }
        )
    }
}

extension InterstitialService: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
       print("Ad did fail to present full screen content.")
     }

     /// Tells the delegate that the ad presented full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
       print("Ad did present full screen content.")
     }

     /// Tells the delegate that the ad dismissed full screen content.
     func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
       print("Ad did dismiss full screen content.")
        needLoadAd()
     }
}
