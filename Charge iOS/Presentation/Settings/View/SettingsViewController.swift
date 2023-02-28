//
//  SettingsViewController.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 22.01.2022.
//

import GoogleMobileAds
import UIKit
import BottomPopup
import TableKit
import MessageUI
import SwiftyUserDefaults

class SettingsViewController: BottomPopupViewController, MFMailComposeViewControllerDelegate  {
    
    // MARK: - Properties
    private let bottomBannerManager = BannerManager.instance
    private let bannerView = GADBannerView()
    
    override var popupHeight: CGFloat { return CGFloat(UIScreen.main.bounds.height / 1.45) }
    override var popupTopCornerRadius: CGFloat { return 25 }
    
    var tableDirector: TableDirector?
    
    @IBOutlet var settingsTableView: UITableView!
    {
        didSet {
            tableDirector = TableDirector(tableView: settingsTableView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillTable()
        addNotification()
        loadBottomBanner()
        removeAds()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bannerView.adSize = getAdaptiveSize()
    }
    
    private func removeAds() {
        if Defaults.subscribtionPurchased {
            bannerView.removeFromSuperview()
        }
    }
    
    private func loadBottomBanner() {
        bottomBannerManager.setupBanner(bannerView)
        bannerView.rootViewController = self
        addBannerToView()
    }
    private func addBannerToView(){
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func getAdaptiveSize() -> GADAdSize {
        var frame: CGRect
        if #available(iOS 11.0, *) {
            frame = view.frame.inset(by: view.safeAreaInsets)
        } else {
            frame = view.frame
        }
        let viewWidth = frame.size.width
        let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        return adSize
    }
    
    private func fillTable() {
        
        //        let tutorial = TableRow<SettingsCell>(item: (L10n.settingsTutorial, Asset.info.image))
        //            .on(.click) { [weak self] _ in
        //
        //                guard let self = self else { return }
        //                let mainStoryboard = UIStoryboard(name: "Preview", bundle: Bundle.main)
        //                let paywall = mainStoryboard.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        //                paywall.modalPresentationStyle = .fullScreen
        //                self.present(paywall, animated: true)
        //                let tutorialController = TutorialAssembly.shared.build()
        //                tutorialController.modalPresentationStyle = .fullScreen
        //                self.navigationController?.pushViewController(tutorialController, animated: true)
        //            }
        
        let getPremium = TableRow<SettingsCell>(item: (L10n.buyPremium, Asset.premium.image))
            .on(.click) { [weak self] _ in
                guard let self = self else { return }
                let paywall = PaywallAssembly.shared.build()
                paywall.modalPresentationStyle = .fullScreen
                self.present(paywall, animated: true)
            }
        
        let share = TableRow<SettingsCell>(item: (L10n.share, Asset.share.image))
            .on(.click) { [weak self] _ in
                guard let self = self else { return }
                self.shareTheApp(appId: Keys.appId)
                
            }
        
        let rateUsRow = TableRow<SettingsCell>(item: (L10n.rateUs, Asset.star.image))
            .on(.click) { [weak self] _ in
                guard let self = self else { return }
                self.openReviewApp(link: "https://itunes.apple.com/ru/app/id\(Keys.appId)?action=write-review")
            }
        
        let contactUs = TableRow<SettingsCell>(item: (L10n.contactUs, Asset.chat.image))
            .on(.click) { [weak self] _ in
                guard let self = self else { return }
                self.sendEmailToSupport(email: Keys.emailAdress)
            }
        
        let privacyPolicyRow = TableRow<SettingsCell>(item: (L10n.settingsPrivacyPolicy, Asset.privacyPolicy.image))
            .on(.click) { [weak self] _ in
                
                guard let self = self else { return }
                self.open(with: URL(string: Keys.privacyPolicyUrl) ?? URL(fileURLWithPath: ""))
            }
        
        let termsOfUseRow = TableRow<SettingsCell>(item: (L10n.settingsTermsOfUse, Asset.termsOfUse.image))
            .on(.click) { [weak self] _ in
                guard let self = self else { return }
                self.open(with: URL(string: Keys.termsOfUseUrl) ?? URL(fileURLWithPath: ""))
            }
        
        var section = TableSection()
        let sectionHeader = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let sectionFooter = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        section.headerView = sectionHeader
        section.footerView = sectionFooter
        if !Defaults.subscribtionPurchased {
            section = TableSection(headerView: sectionHeader, footerView: sectionFooter,
                                   rows: [
                                    getPremium,
                                    share,
                                    rateUsRow,
                                    contactUs,
                                    privacyPolicyRow,
                                    termsOfUseRow
                                   ]
            )
        } else {
            
            section = TableSection(headerView: sectionHeader, footerView: sectionFooter,
                                   rows: [
                                    share,
                                    rateUsRow,
                                    contactUs,
                                    privacyPolicyRow,
                                    termsOfUseRow
                                   ]
            )
        }
        
        tableDirector? += section
        
        settingsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: CGFloat.leastNormalMagnitude))
        settingsTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: CGFloat.leastNormalMagnitude))
    }
    
    private func openReviewApp(link: String) {
        let url = URL(string: link)
        guard let urlGroup = url else { return }
        open(with: urlGroup)
    }
    
    private func open(with url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    private func shareTheApp(appId: String) {
        let appToShare = ["apps.apple.com/us/app/id" + appId]
        let activityViewController = UIActivityViewController(activityItems: appToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func sendEmailToSupport(email: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            
            present(mail, animated: true)
        } else {
            print("Failed to send a message")
        }
    }
    
    internal func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    private func addNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupNextScreen), name: UIDevice.batteryStateDidChangeNotification, object: nil)
    }
    
    @objc func setupNextScreen() {
        Defaults.unpluggedLaunch = false
        if UIDevice.current.batteryState != .unplugged {
            let storyboard = UIStoryboard(name: "ChargingAnimation", bundle: Bundle.main)
            let preview = storyboard.instantiateViewController(withIdentifier: "ChargingAnimationViewController") as! ChargingAnimationViewController
            preview.modalPresentationStyle = .fullScreen
            self.present(preview, animated: false)
        }
    }
}
