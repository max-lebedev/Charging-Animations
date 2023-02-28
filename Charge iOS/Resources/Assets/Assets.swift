// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal static let background = ImageAsset(name: "Background")
  internal static let continueButton = ImageAsset(name: "ContinueButton")
  internal static let notNowButton = ImageAsset(name: "notNowButton")
  internal static let startButton = ImageAsset(name: "startButton")
  internal static let whiteColor = ColorAsset(name: "WhiteColor")
  internal static let _10th = ImageAsset(name: "10th")
  internal static let _5th = ImageAsset(name: "5th")
  internal static let _6th = ImageAsset(name: "6th")
  internal static let _7th = ImageAsset(name: "7th")
  internal static let _8th = ImageAsset(name: "8th")
  internal static let _9th = ImageAsset(name: "9th")
  internal static let check = ImageAsset(name: "Check")
  internal static let ellipse = ImageAsset(name: "Ellipse")
  internal static let animation = ImageAsset(name: "animation")
  internal static let animation2 = ImageAsset(name: "animation2")
  internal static let animationPreview0 = ImageAsset(name: "animationPreview0")
  internal static let animationPreview1 = ImageAsset(name: "animationPreview1")
  internal static let animationPreview2 = ImageAsset(name: "animationPreview2")
  internal static let animationPreview4 = ImageAsset(name: "animationPreview4")
  internal static let lightning = ImageAsset(name: "lightning")
  internal static let menu = ImageAsset(name: "menu")
  internal static let testProgress = ImageAsset(name: "testProgress")
  internal static let chargeAnimation = ImageAsset(name: "ChargeAnimation")
  internal static let manual = ImageAsset(name: "Manual")
  internal static let circle = ImageAsset(name: "circle")
  internal static let closeButton = ImageAsset(name: "closeButton")
  internal static let cuate = ImageAsset(name: "cuate")
  internal static let improve = ImageAsset(name: "improve")
  internal static let removeAds = ImageAsset(name: "remove-ads")
  internal static let smallCirlce = ImageAsset(name: "smallCirlce")
  internal static let support = ImageAsset(name: "support")
  internal static let back = ImageAsset(name: "back")
  internal static let preview = ImageAsset(name: "preview")
  internal static let line = ImageAsset(name: "Line")
  internal static let chat = ImageAsset(name: "chat")
  internal static let info = ImageAsset(name: "info")
  internal static let premium = ImageAsset(name: "premium")
  internal static let privacyPolicy = ImageAsset(name: "privacy-policy")
  internal static let share = ImageAsset(name: "share")
  internal static let star = ImageAsset(name: "star")
  internal static let termsOfUse = ImageAsset(name: "termsOfUse")
  internal static let cat = ImageAsset(name: "cat")
  internal static let currentDot = ImageAsset(name: "currentDot")
  internal static let dot = ImageAsset(name: "dot")
  internal static let tutorial1En = ImageAsset(name: "tutorial1En")
  internal static let tutorial2En = ImageAsset(name: "tutorial2En")
  internal static let tutorial3En = ImageAsset(name: "tutorial3En")
  internal static let tutorial4En = ImageAsset(name: "tutorial4En")
  internal static let help = ImageAsset(name: "help")
  internal static let nextButton = ImageAsset(name: "nextButton")
  internal static let phone = ImageAsset(name: "phone")
  internal static let robot = ImageAsset(name: "robot")
  internal static let openShortcuts = ImageAsset(name: "openShortcuts")
  internal static let tutorial1 = ImageAsset(name: "tutorial1")
  internal static let tutorial2 = ImageAsset(name: "tutorial2")
  internal static let tutorial3 = ImageAsset(name: "tutorial3")
  internal static let tutorial4 = ImageAsset(name: "tutorial4")
  internal static let success = ImageAsset(name: "success")
  internal static let tutorialButton = ImageAsset(name: "tutorialButton")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
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
