//
//  OnboardingAssembly.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 27.12.2021.
//

import UIKit

class OnboardingAssembly: Assembly {
    private init() {}
    static let shared = OnboardingAssembly()
    func build() -> UIViewController {

        guard let onboardingVC = StoryboardScene.Onboarding.storyboard.instantiateInitialViewController() as? OnboardingViewController  else {
            return UIViewController()
        }

        let dataArray: [OnboardingModel] = [
            OnboardingModel(image: Asset.chargeAnimation.image, titleText: L10n.firstOnboardingTitle, descriptionText: L10n.firstOnboardingSubtitle),
            OnboardingModel(image: Asset.manual.image, titleText: L10n.secondOnboardingTitle, descriptionText: L10n.secondOnboardingSubtitle)
            
        ]

        let presenter = OnboardingPresenter(view: onboardingVC, dataArray: dataArray)
        onboardingVC.presenter = presenter

        return onboardingVC
    }
}
