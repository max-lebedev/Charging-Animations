//
//  BannerManager.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 14.02.2022.
//

import Foundation
import SwiftyUserDefaults
import GoogleMobileAds

class BannerManager {
    static let instance = BannerManager()
    
    func setupBanner(_ bannerView: GADBannerView) {
        if !Defaults.subscribtionPurchased {
            let request = GADRequest()
            bannerView.adUnitID = Keys.mainBannerId
            bannerView.load(request)
        }
    }
}
