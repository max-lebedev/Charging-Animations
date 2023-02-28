//
//  SceneDelegate.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 23.12.2021.
//

import UIKit
import SwiftyUserDefaults

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        if UIDevice.current.batteryState != .unplugged && Defaults.onboardingSeen {
            Defaults.unpluggedLaunch = false
            let storyboard = UIStoryboard(name: "ChargingAnimation", bundle: Bundle.main)
            let preview = storyboard.instantiateViewController(withIdentifier: "ChargingAnimationViewController") as! ChargingAnimationViewController
            self.window?.rootViewController = preview

        } else if UIDevice.current.batteryState == .unplugged || !Defaults.onboardingSeen {
            setRootViewController()
        }
    }
    
    private func setRootViewController() {
        
        Defaults.unpluggedLaunch = true
        
        if !Defaults.onboardingSeen {
            loadAndSavePrices()
            loadOnboardingVC()
            
        } else {
            loadMainMenuController()
        }
    }
    
    private func loadOnboardingVC() {
        let onboardingVC = OnboardingAssembly.shared.build()
        self.window?.rootViewController = onboardingVC
    }
    
    private func loadMainMenuController() {
        let mainMenuController = MainMenuAssembly.shared.build()
        self.window?.rootViewController = mainMenuController
    }
    
    func loadAndSavePrices() {
        SubscriptionManager.instance.getProductInfo(productId: Keys.productIds[0]) { price in
            Defaults.montlyPrice = price
        }
        SubscriptionManager.instance.getProductInfo(productId: Keys.productIds[1]) { price in
            Defaults.yearlyPrice = price
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    // MARK: - Private methods
    
}

