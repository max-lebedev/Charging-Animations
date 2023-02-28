//
//  BeginTutorialViewController.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 26.01.2022.
//

import UIKit
import SwiftyUserDefaults

class BeginTutorialViewController: UIViewController {
    
    @IBOutlet private var beginTutorialTitle: UILabel!
    @IBOutlet private var beginTutorialFirstLabel: UILabel!
    @IBOutlet private var beginTutorialSecondLabel: UILabel!
    @IBOutlet private var openShortcutsButton: UIButton!
    @IBOutlet private var continueButton: UIButton!
    @IBOutlet private var shortcutsImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        addNotification()
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        Defaults.needOpenInterstitial = true
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func openShortcutsButtonTapped(_ sender: UIButton) {
        openApp("shortcuts://")
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Tutorial", bundle: Bundle.main)
//        let tutorial = storyboard.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        let tutorial = TutorialAssembly.shared.buildTutorial()
        tutorial.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(tutorial, animated: true)

    }
    
    private func localize() {
        beginTutorialTitle.text = L10n.initialTutorialTitle
        beginTutorialFirstLabel.text = L10n.initialTutorialText
        beginTutorialSecondLabel.text = L10n.initialTutorialSecondText
        openShortcutsButton.setTitle(L10n.openShortcuts,for:.normal)
        continueButton.setTitle(L10n.continue,for:.normal)
    }
    
    private func openApp(_ urlstring:String) {
        
        var responder: UIResponder? = self as UIResponder
        let selector = #selector(openURL(_:))
        while responder != nil {
            if responder!.responds(to: selector) && responder != self {
                responder!.perform(selector, with: URL(string: urlstring)!)
                return
            }
            responder = responder?.next
        }
    }
    @objc func openURL(_ url: URL) {
        return
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
