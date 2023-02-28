//
//  TutorialAssembly.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 26.01.2022.
//

import UIKit

class TutorialAssembly {
    private init() {}
    static let shared = TutorialAssembly()
    func build() -> UIViewController {
        guard let tutorial = StoryboardScene.BeginTutorial.storyboard.instantiateInitialViewController() as? BeginTutorialViewController  else {
            return UIViewController()
        }
        return tutorial
    }
    
    func buildTutorial() -> UIViewController {

        guard let tutorialVC = StoryboardScene.Tutorial.storyboard.instantiateInitialViewController() as? TutorialViewController  else {
            return UIViewController()
        }

        let dataArray: [TutorialModel] = [
            TutorialModel(image: Asset.tutorial1.image, description: L10n.firstTutorial),
            TutorialModel(image: Asset.tutorial2.image, description: L10n.secondTutorial),
            TutorialModel(image: Asset.tutorial3.image, description: L10n.thirdTutorial),
            TutorialModel(image: Asset.tutorial4.image, description: L10n.fourthTutorial),
            TutorialModel(image: Asset.phone.image, description: L10n.fifthTutorial),
            
        ]

        let presenter = TutorialPresenter(view: tutorialVC , dataArray: dataArray)
        tutorialVC.presenter = presenter

        return tutorialVC
    }
    
    func buildDoesntWork() -> UIViewController {
        guard let doesntWork = StoryboardScene.DoesntWork.storyboard.instantiateInitialViewController() as? BeginTutorialViewController  else {
            return UIViewController()
        }
        return doesntWork
    }
    
}
