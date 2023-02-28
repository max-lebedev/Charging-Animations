//
//  MainMenuAssembly.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 21.01.2022.
//

import UIKit

protocol MainAssembly {
    func build() -> UIViewController
}

class MainMenuAssembly: MainAssembly {
    private init() {}
    static let shared = MainMenuAssembly()
    func build() -> UIViewController {
        
        guard let mainMenuController = StoryboardScene.MainMenu.storyboard.instantiateInitialViewController() else {
            return MainMenuViewController()
        }
        
//        let mainStoryboard = UIStoryboard(name: "MainMenu", bundle: Bundle.main)
//        let mainMenuController = mainStoryboard.instantiateViewController(withIdentifier: "MainMenuViewController") as! MainMenuViewController
////
//        let dataArray: [MainMenuModel] = [
//            MainMenuModel(image: Asset.animation.image),
//            MainMenuModel(image: Asset.animation2.image),
//            MainMenuModel(image: Asset.animation.image)
//        ]
//
//
//        mainMenuController.presenter = presenter
        
//        let mainVC = mainMenuController.navigationController?.viewControllers. as! MainMenuViewController
//        
//        let presenter = MainMenuPresenter(view: mainMenuController as! MainMenuProtocol, dataArray: dataArray)
//        mainVC.presenter = presenter
        
        return mainMenuController
    }
}
