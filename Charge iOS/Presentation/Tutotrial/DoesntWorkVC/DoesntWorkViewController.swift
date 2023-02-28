//
//  DoesntWorkViewController.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 28.01.2022.
//

import UIKit
import BottomPopup
import Lottie
import SwiftyUserDefaults


class DoesntWorkViewController: BottomPopupViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var firslDescriptionLabel: UILabel!
    @IBOutlet var secondDescriptionLabel: UILabel!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var helpAnimation: AnimationView!
    @IBOutlet var setupAgainButton: UIButton!
    
    
    override var popupHeight: CGFloat { return CGFloat(UIScreen.main.bounds.height / 1.4) }
    override var popupTopCornerRadius: CGFloat { return 25 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        setupAnimation()
        addNotification()
    }
    
    @IBAction func startTutorialButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    private func setupAnimation() {
        helpAnimation.contentMode = .scaleAspectFit
        helpAnimation.loopMode = .loop
        helpAnimation.animationSpeed = 0.4
        helpAnimation.play()
    }
    
    private func localize() {
        titleLabel.text = L10n.dontWorry
        firslDescriptionLabel.text = L10n.helpFirstText
        secondDescriptionLabel.text = L10n.helpSecondtext
        setupAgainButton.setTitle(L10n.setupAgain, for: .normal)
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

