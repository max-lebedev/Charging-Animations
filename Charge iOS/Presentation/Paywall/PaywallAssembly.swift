//
//  PaywallAssembly.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 20.01.2022.
//

import UIKit

class PaywallAssembly {
    private init() {}
    static let shared = PaywallAssembly()
    func build() -> UIViewController {
        guard let paywall = StoryboardScene.Paywall.storyboard.instantiateInitialViewController() as? PaywallViewController  else {
            return UIViewController()
        }
        
        return paywall
    }
}
