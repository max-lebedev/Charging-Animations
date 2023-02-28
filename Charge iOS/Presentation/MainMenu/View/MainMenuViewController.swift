//
//  MainMenuViewController.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 13.01.2022.
//

import UIKit
import AdSupport
import AppTrackingTransparency
import GoogleMobileAds
import SwiftyUserDefaults
import KDCircularProgress

class MainMenuViewController: UIViewController {
    
    // MARK: - Private properties
    private let mainMenuCellIdentifier = "MainMenuCell"
    private var timer = Timer()
    private let topBannerManager = BannerManager.instance
    private let bannerView = GADBannerView()
    private let interstitialService = InterstitialService.instance
    private var data: [MainMenuModel] = [
                MainMenuModel(image: Asset._10th.image),
                MainMenuModel(image: Asset.animationPreview0.image),
                MainMenuModel(image: Asset._5th.image),
                MainMenuModel(image: Asset._6th.image),
                MainMenuModel(image: Asset._7th.image),
                MainMenuModel(image: Asset._9th.image),
                MainMenuModel(image: Asset.animationPreview1.image),
                MainMenuModel(image: Asset.animationPreview2.image),
                MainMenuModel(image: Asset._8th.image),
                MainMenuModel(image: Asset.animationPreview4.image)
            ]
  
//    var presenter: MainMenuPresenterImpl?
    
    @IBOutlet private var tutorialButton: UIButton!
    @IBOutlet private var mainMenuCollectionView: UICollectionView!
    @IBOutlet private var chargingAnimationLabel: UILabel!
    @IBOutlet private var animationGalleryLabel: UILabel!
    @IBOutlet private var batteryLevel: UILabel!
    @IBOutlet var progressBar: UIImageView!
    @IBOutlet var labelConstraint: NSLayoutConstraint!
    @IBOutlet var buttonConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.presenter?.loadData()
        setupMainMenuCollectionView()
        setupTimer()
        observeBattery()
        localize()
        addNotification()
        loadTopBanner()
        removeAds()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadPaywall()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bannerView.adSize = GADAdSizeBanner
        requestIDFAPermission()
        DispatchQueue.main.async {
            self.mainMenuCollectionView.reloadData()
        }
        DispatchQueue.main.async {
            print(Defaults.previewCount)
            if Defaults.needOpenInterstitial && Defaults.previewCount != 0 {
                self.loadInterstitial()
                Defaults.needOpenInterstitial = false
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupProgressBar()
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        
        let mainStoryboard = UIStoryboard(name: "Settings", bundle: Bundle.main)
        let settings = mainStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.present(settings, animated: true)
    }
    @IBAction func instructionButtonTapped(_ sender: UIButton) {
        let tutorialController = TutorialAssembly.shared.build()
        tutorialController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(tutorialController, animated: true)
    }
    
    // MARK: - Private methods
    
    private func removeAds() {
        if Defaults.subscribtionPurchased {
            bannerView.removeFromSuperview()
            labelConstraint.constant = labelConstraint.constant / 2
            buttonConstraint.constant = buttonConstraint.constant / 2
        }
    }
    
    private func loadTopBanner() {
        topBannerManager.setupBanner(bannerView)
        bannerView.rootViewController = self
        addBannerToView()
    }
    private func addBannerToView(){
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func loadInterstitial() {
        if InterstitialService.instance.interstitial != nil {
            InterstitialService.instance.interstitial?.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    private func setupMainMenuCollectionView() {
        mainMenuCollectionView.dataSource = self
        mainMenuCollectionView.delegate = self
        mainMenuCollectionView.register(UINib(nibName: mainMenuCellIdentifier, bundle: nil), forCellWithReuseIdentifier: mainMenuCellIdentifier)
        mainMenuCollectionView.isScrollEnabled = true
    }
    
    private func localize() {
        tutorialButton.setTitle(L10n.tutorial,for:.normal)
        chargingAnimationLabel.text = L10n.chargingAnimation
        animationGalleryLabel.text = L10n.animationGallery
    }
    
    private func loadPaywall(){
        if Defaults.unpluggedLaunch == true && !Defaults.subscribtionPurchased {
            let paywallVC = PaywallAssembly.shared.build()
            paywallVC.modalPresentationStyle = .fullScreen
            self.present(paywallVC, animated: true)
        }
    }
    
    private func setupTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { _ in
            self.observeBattery()
            })
    }
    
    private func observeBattery() {
        BatteryManager.shared.battery.observe(on: self) { battery in
            let text: String = battery.level == -1 ? "..." : "\(Int(battery.level * 100))%"
            DispatchQueue.main.async {
                self.batteryLevel.text = text
            }
        }
    }
    
    private func setupProgressBar() {
        BatteryManager.shared.battery.observe(on: self) { battery in
            let progress: KDCircularProgress
            progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: self.progressBar.frame.width + 38, height: self.progressBar.frame.height + 38))
            progress.startAngle = -90
            progress.progressThickness = 0.2
            progress.trackThickness = 0.4
            progress.trackColor = .white
            progress.clockwise = true
            progress.gradientRotateSpeed = 0.25
            progress.roundedCorners = true
            progress.glowMode = .constant
            progress.glowAmount = 0.35
            progress.roundedCorners = true
            progress.angle = Double(battery.level * 360)
            progress.set(colors: UIColor(red: 0.831, green: 0.187, blue: 0.896, alpha: 1),
                         UIColor(red: 0.252, green: 0.651, blue: 0.875, alpha: 1),
                         UIColor(red: 0.337, green: 0.325, blue: 0.851, alpha: 1))
            progress.center = CGPoint(x: self.progressBar.center.x, y: self.progressBar.center.y)
            self.view.addSubview(progress)
        }
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
    
    private func requestIDFAPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Now that we are authorized we can get the IDFA
                    print(ASIdentifierManager.shared().advertisingIdentifier)
                    break
                case .denied:
                    break
                case .notDetermined:
                    break
                case .restricted:
                    break
                @unknown default:
                    print("Unknown")
                }
            }
        }
    }
}

extension MainMenuViewController: MainMenuProtocol {
    func setData(data: [MainMenuModel]) {
        self.data = data
    }
}

// MARK: - UICollectionViewDataSource
extension MainMenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let data = data else { return 3 }
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainMenuCollectionView.dequeueReusableCell(
            withReuseIdentifier: mainMenuCellIdentifier,
            for: indexPath
        ) as? MainMenuCell else {
            return UICollectionViewCell()
        }
        
        collectionView.layer.masksToBounds = false
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = false
        
        if indexPath.row == Defaults.selectedAnimationIndex {
            cell.checkImage.isHidden = false
        } else {
            cell.checkImage.isHidden = true
        }
        
//        if let data = data {
            let item = data[indexPath.item]
            cell.setup(with: item)
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Preview", bundle: Bundle.main)
        let preview = mainStoryboard.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        preview.modalPresentationStyle = .fullScreen
        
//        if let data = data {
        let previewModel = data[indexPath.row]
        preview.setup(with: previewModel)
//        }
        preview.getIndex(with: indexPath.row)
        Defaults.previewCount += 1
        navigationController?.pushViewController(preview, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegate
extension MainMenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.height / 2
        return CGSize(width: width, height: collectionView.frame.height)
    }
}
