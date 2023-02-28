//
//  SetupAppViewController.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 29.01.2022.
//

import UIKit
import SwiftyUserDefaults

class SetupAppViewController: UIViewController {
    
    @IBOutlet var setupView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var startLabel: UILabel!
    @IBOutlet var notNowButton: UIButton!
    @IBOutlet var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        addNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        makeRoundedAndShadowed(view: setupView)
    }
    
    
    @IBAction func notNowButtonPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: false)
//        self.dismiss(animated: false)
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        let tutorialController = TutorialAssembly.shared.build()
        tutorialController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(tutorialController, animated: true)
    }
    
    private func makeRoundedAndShadowed(view: UIView) {
        let shadowLayer = CAShapeLayer()
        
        view.layer.cornerRadius = 30
        shadowLayer.path = UIBezierPath(roundedRect: view.bounds,
                                        cornerRadius: view.layer.cornerRadius).cgPath
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.fillColor = view.backgroundColor?.cgColor
        shadowLayer.shadowColor = UIColor(red: 0.825, green: 0.074, blue: 0.842, alpha: 0.65).cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 10
        view.layer.insertSublayer(shadowLayer, at: 0)
        
        let secondShadowLayer = CAShapeLayer()
        
        view.layer.cornerRadius = 30
        secondShadowLayer.path = UIBezierPath(roundedRect: view.bounds,
                                        cornerRadius: view.layer.cornerRadius).cgPath
        secondShadowLayer.shadowPath = shadowLayer.path
        secondShadowLayer.fillColor = view.backgroundColor?.cgColor
        secondShadowLayer.shadowColor = UIColor(red: 0.333, green: 0.329, blue: 0.855, alpha: 1).cgColor
        secondShadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        secondShadowLayer.shadowOpacity = 1
        secondShadowLayer.shadowRadius = 15
        view.layer.insertSublayer(secondShadowLayer, at: 0)
    }
    
    private func localize() {
        titleLabel.text = L10n.setupApp
        descriptionLabel.text = L10n.setupText
        startLabel.text = L10n.start
        notNowButton.setTitle(L10n.notNow, for: .normal)
        startButton.setTitle(L10n.startButton, for: .normal)
    }
    
    private func addNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupNextScreen), name: UIDevice.batteryStateDidChangeNotification, object: nil)
    }
    
    @objc func setupNextScreen() {
        if UIDevice.current.batteryState != .unplugged {
            Defaults.unpluggedLaunch = false
            let storyboard = UIStoryboard(name: "ChargingAnimation", bundle: Bundle.main)
            let preview = storyboard.instantiateViewController(withIdentifier: "ChargingAnimationViewController") as! ChargingAnimationViewController
            preview.modalPresentationStyle = .fullScreen
            self.present(preview, animated: false)
        }
    }
}
