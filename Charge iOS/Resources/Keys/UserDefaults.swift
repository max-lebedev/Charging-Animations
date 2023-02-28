//
//  UserDefaults.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 20.01.2022.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    var onboardingSeen: DefaultsKey<Bool> { .init("onboardingSeen", defaultValue: false) }
    var launchCount: DefaultsKey<Int> { .init("launchCount", defaultValue: 0) }
    var subscribtionPurchased: DefaultsKey<Bool> { .init("subscribtionPurchased", defaultValue: false) }
    var firstAnimationSetup: DefaultsKey<Bool> { .init("firstAnimationSetup", defaultValue: true) }
    var animationSelected: DefaultsKey<Bool> { .init("animationSelected", defaultValue: false) }
    
    var batteryLevelHidden: DefaultsKey<Bool> { .init("batteryLevelHidden", defaultValue: false) }
    var dateHidden: DefaultsKey<Bool> { .init("dateHidden", defaultValue: false) }
    var soundHidden: DefaultsKey<Bool> { .init("soundHidden", defaultValue: false) }
    
    var pluggedBatteryLevelHidden: DefaultsKey<Bool> { .init("pluggedBatteryLevelHidden", defaultValue: false) }
    var pluggeDateHidden: DefaultsKey<Bool> { .init("pluggeDateHidden", defaultValue: false) }
    var pluggedSoundHidden: DefaultsKey<Bool> { .init("pluggedSoundHidden", defaultValue: false) }
    
    var unpluggedLaunch: DefaultsKey<Bool> { .init("unpluggedLaunch", defaultValue: false) }
    var openPreview: DefaultsKey<Bool> { .init("openPreview", defaultValue: false) }
    
    var selectedAnimationIndex: DefaultsKey<Int> { .init("selectedAnimationIndex", defaultValue: 0) }
    
    var needOpenInterstitial: DefaultsKey<Bool> { .init("needOpenInterstitial", defaultValue: false) }
    
    var montlyPrice: DefaultsKey<String?> { .init("montlyPrice", defaultValue: nil)}
    var yearlyPrice: DefaultsKey<String?> { .init("yearlyPrice", defaultValue: nil)}
    var previewCount: DefaultsKey<Int> { .init("previewCount", defaultValue: 0) }
}
