// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length implicit_return

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum BeginTutorial: StoryboardType {
    internal static let storyboardName = "BeginTutorial"

    internal static let initialScene = InitialSceneType<BeginTutorialViewController>(storyboard: BeginTutorial.self)
  }
  internal enum ChargingAnimation: StoryboardType {
    internal static let storyboardName = "ChargingAnimation"

    internal static let initialScene = InitialSceneType<ChargingAnimationViewController>(storyboard: ChargingAnimation.self)

    internal static let chargingAnimationViewController = SceneType<ChargingAnimationViewController>(storyboard: ChargingAnimation.self, identifier: "ChargingAnimationViewController")
  }
  internal enum DoesntWork: StoryboardType {
    internal static let storyboardName = "DoesntWork"

    internal static let initialScene = InitialSceneType<DoesntWorkViewController>(storyboard: DoesntWork.self)

    internal static let doesntWorkViewController = SceneType<DoesntWorkViewController>(storyboard: DoesntWork.self, identifier: "DoesntWorkViewController")
  }
  internal enum LaunchScreen: StoryboardType {
    internal static let storyboardName = "Launch Screen"

    internal static let initialScene = InitialSceneType<UIKit.UIViewController>(storyboard: LaunchScreen.self)
  }
  internal enum MainMenu: StoryboardType {
    internal static let storyboardName = "MainMenu"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: MainMenu.self)

    internal static let mainMenuViewController = SceneType<MainMenuViewController>(storyboard: MainMenu.self, identifier: "MainMenuViewController")
  }
  internal enum Onboarding: StoryboardType {
    internal static let storyboardName = "Onboarding"

    internal static let initialScene = InitialSceneType<OnboardingViewController>(storyboard: Onboarding.self)

    internal static let onboardingViewController = SceneType<OnboardingViewController>(storyboard: Onboarding.self, identifier: "OnboardingViewController")
  }
  internal enum Paywall: StoryboardType {
    internal static let storyboardName = "Paywall"

    internal static let initialScene = InitialSceneType<PaywallViewController>(storyboard: Paywall.self)

    internal static let paywallViewController = SceneType<PaywallViewController>(storyboard: Paywall.self, identifier: "PaywallViewController")
  }
  internal enum Preview: StoryboardType {
    internal static let storyboardName = "Preview"

    internal static let initialScene = InitialSceneType<PreviewViewController>(storyboard: Preview.self)

    internal static let previewViewController = SceneType<PreviewViewController>(storyboard: Preview.self, identifier: "PreviewViewController")
  }
  internal enum Settings: StoryboardType {
    internal static let storyboardName = "Settings"

    internal static let initialScene = InitialSceneType<SettingsViewController>(storyboard: Settings.self)

    internal static let settingsViewController = SceneType<SettingsViewController>(storyboard: Settings.self, identifier: "SettingsViewController")
  }
  internal enum SetupApp: StoryboardType {
    internal static let storyboardName = "SetupApp"

    internal static let initialScene = InitialSceneType<SetupAppViewController>(storyboard: SetupApp.self)

    internal static let setupAppViewController = SceneType<SetupAppViewController>(storyboard: SetupApp.self, identifier: "SetupAppViewController")
  }
  internal enum Tutorial: StoryboardType {
    internal static let storyboardName = "Tutorial"

    internal static let initialScene = InitialSceneType<TutorialViewController>(storyboard: Tutorial.self)

    internal static let tutorialViewController = SceneType<TutorialViewController>(storyboard: Tutorial.self, identifier: "TutorialViewController")
  }
  internal enum TutorialResault: StoryboardType {
    internal static let storyboardName = "TutorialResault"

    internal static let initialScene = InitialSceneType<TutorialResaultViewController>(storyboard: TutorialResault.self)
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: BundleToken.bundle)
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    return storyboard.storyboard.instantiateViewController(identifier: identifier, creator: block)
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController(creator: block) else {
      fatalError("Storyboard \(storyboard.storyboardName) does not have an initial scene.")
    }
    return controller
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
