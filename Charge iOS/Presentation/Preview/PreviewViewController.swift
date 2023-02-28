//
//  PreviewViewController.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 21.01.2022.
//

import UIKit
import SwiftyUserDefaults

class PreviewViewController: UIViewController {
    
    var image: UIImage!
    var index: Int?
    private let interstitialService = InterstitialService.instance
    
    @IBOutlet var animationSoundLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var chargePercentLabel: UILabel!
    @IBOutlet var previewLabel: UILabel!
    @IBOutlet var viewAnimatioImage: UIView!
    @IBOutlet var animationImage: UIImageView!
    @IBOutlet var batteryLevelSwitch: UISwitch!
    @IBOutlet var dateSwitch: UISwitch!
    @IBOutlet var soundSwitch: UISwitch!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var setupAnimationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimatioView()
        localize()
        setupSwitches()
        animationImage.image = image
        addNotification()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        Defaults.previewCount += 1
//    }
//
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            if Defaults.previewCount == 3 {
                Defaults.previewCount = 0
                self.loadInterstitial()
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func previewButoonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "ChargingAnimation", bundle: Bundle.main)
        let preview = storyboard.instantiateViewController(withIdentifier: "ChargingAnimationViewController") as! ChargingAnimationViewController
        preview.modalPresentationStyle = .fullScreen
        guard let index = index else { return } 
        preview.getIndex(with: index)
        Defaults.openPreview = true
        self.present(preview, animated: false)
    }
    
    @IBAction func setupButtonPressed(_ sender: UIButton) {
        guard let index = index else { return }
        Defaults.selectedAnimationIndex = index
        Defaults.animationSelected = true
        Defaults.pluggedBatteryLevelHidden = Defaults.batteryLevelHidden
        Defaults.pluggeDateHidden = Defaults.dateHidden
        Defaults.pluggedSoundHidden = Defaults.soundHidden
        Defaults.needOpenInterstitial = true
        if Defaults.firstAnimationSetup == true {
            let mainStoryboard = UIStoryboard(name: "SetupApp", bundle: Bundle.main)
            let setupApp = mainStoryboard.instantiateViewController(withIdentifier: "SetupAppViewController") as! SetupAppViewController
            setupApp.modalPresentationStyle = .popover
            self.navigationController?.pushViewController(setupApp, animated: false)
            Defaults.firstAnimationSetup = false
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func setup(with item: MainMenuModel) {
        image = item.image
    }
    
    func getIndex(with item: Int) {
        index = item
    }
    
    private func loadInterstitial() {
        if InterstitialService.instance.interstitial != nil {
            InterstitialService.instance.interstitial?.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    private func setupAnimatioView() {

        viewAnimatioImage.layer.masksToBounds = false
        viewAnimatioImage.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        viewAnimatioImage.layer.shadowColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
        viewAnimatioImage.layer.shadowOpacity = 1
        viewAnimatioImage.layer.shadowRadius = 4
        animationImage.layer.cornerRadius = 15
        viewAnimatioImage.backgroundColor = .clear
        
    }
    
    private func localize() {
        previewLabel.text = L10n.preview
        chargePercentLabel.text = L10n.batteryLevel
        dateLabel.text = L10n.dateAndTime
        animationSoundLabel.text = L10n.sound
        setupAnimationButton.setTitle(L10n.setupAnimation,for:.normal)
    }
    
    private func setupSwitches() {
        
        if Defaults.batteryLevelHidden {
            batteryLevelSwitch.isOn = false
        } else {
            batteryLevelSwitch.isOn = true
        }
        
        if Defaults.dateHidden {
            dateSwitch.isOn = false
        } else {
            dateSwitch.isOn = true
        }
        
        if Defaults.soundHidden {
            soundSwitch.isOn = false
        } else {
            soundSwitch.isOn = true
        }
        
        batteryLevelSwitch.addTarget(self, action: #selector(batterySwitchChanged), for: .valueChanged)
        dateSwitch.addTarget(self, action: #selector(dateSwitchChanged), for: .valueChanged)
        soundSwitch.addTarget(self, action: #selector(soundSwitchChanged), for: .valueChanged)
    }
    
    @objc
    func batterySwitchChanged(switchState: UISwitch) {
        if switchState.isOn {
            Defaults.batteryLevelHidden = false
        } else {
            Defaults.batteryLevelHidden = true
        }
    }

    @objc
    func dateSwitchChanged(switchState: UISwitch) {
        if switchState.isOn {
            Defaults.dateHidden = false
        } else {
            Defaults.dateHidden = true
        }
    }
    
    @objc
    func soundSwitchChanged(switchState: UISwitch) {
        if switchState.isOn {
            Defaults.soundHidden = false
        } else {
            Defaults.soundHidden = true
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

}
