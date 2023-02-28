//
//  ChargingAnimationViewController.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 29.01.2022.
//

import UIKit
import Lottie
import SwiftyUserDefaults
import AVFoundation

class ChargingAnimationViewController: UIViewController {
    
    private var timer = Timer()
    var animationName = ["10th", "rocketa", "5th", "6th", "7th", "9th", "firstAnimation", "Second", "8th", "fourth"]
    var trackName = ["Test",
                     "Test",
                     "TestTrack2",
                     "TestTrack2",
                     "Test",
                     "Test",
                     "TestTrack2",
                     "TestTrack2",
                     "TestTrack2",
                     "TestTrack2",
                     "TestTrack3"]
    var index: Int?
    var player: AVAudioPlayer?
    var videoPlayer: AVPlayer?
    
    @IBOutlet var animationView: AnimationView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var batteryLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var videoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationOrLotiie()
        setupUI()
        updateUI()
        setupGesture()
        setupDateAndTime()
        setupTimer()
        observeBattery()
        addNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
//            self.playSound()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.player?.stop()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        Defaults.openPreview = false
        self.dismiss(animated: false)
    }
    
    private func setupUI() {
        
        if Defaults.openPreview == true {
            backButton.isHidden = false
        } else {
            backButton.isHidden = true
        }
        if UIDevice.current.batteryState == .unplugged {
            if Defaults.batteryLevelHidden {
                batteryLabel.isHidden = true
            } else {
                batteryLabel.isHidden = false
            }
            
            if Defaults.dateHidden {
                timeLabel.isHidden = true
                dateLabel.isHidden = true
            } else {
                timeLabel.isHidden = false
                dateLabel.isHidden = false
            }
        } else if UIDevice.current.batteryState != .unplugged {
            if Defaults.pluggedBatteryLevelHidden {
                batteryLabel.isHidden = true
            } else {
                batteryLabel.isHidden = false
            }
            
            if Defaults.pluggeDateHidden {
                timeLabel.isHidden = true
                dateLabel.isHidden = true
            } else {
                timeLabel.isHidden = false
                dateLabel.isHidden = false
            }
        }
    }
    
    private func updateUI() {
        guard let index = index else { return }
        if (index < 5 && Defaults.openPreview) || (Defaults.selectedAnimationIndex < 5 && !Defaults.openPreview) {
            animationView.contentMode = .scaleAspectFill
        }
    }
    
    private func animationOrLotiie() {
        if (index == 0 && Defaults.openPreview) || (Defaults.selectedAnimationIndex == 0 && !Defaults.openPreview) {
            animationView.isHidden = true
            videoView.isHidden = false
            playVideo()
        } else {
            videoView.isHidden = true
            animationView.isHidden = false
            setupAnimation()
        }
    }
    
    private func setupAnimation() {
        
        if UIDevice.current.batteryState == .unplugged {
            guard let index = index else { return }
            animationView.animation = Animation.named(animationName[index])
        } else if UIDevice.current.batteryState != .unplugged {
            animationView.animation = Animation.named(animationName[Defaults.selectedAnimationIndex])
        }
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.75
        animationView.play()
    }
    
    private func playVideo() {
        if UIDevice.current.batteryState == .unplugged {
            guard let index = index else { return }
            guard let url = Bundle.main.url(forResource: animationName[index], withExtension: "m4v") else { return }
            videoPlayer = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: videoPlayer)
            playerLayer.frame = self.videoView.bounds
            self.videoView.layer.addSublayer(playerLayer)
            guard let videoPlayer = videoPlayer else { return }
            videoPlayer.play()
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
                videoPlayer.seek(to: .zero)
                videoPlayer.play()
            }
        } else if UIDevice.current.batteryState != .unplugged {
            guard let url = Bundle.main.url(forResource: animationName[Defaults.selectedAnimationIndex], withExtension: "m4v") else { return }
            videoPlayer = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: videoPlayer)
            playerLayer.frame = self.videoView.bounds
            self.videoView.layer.addSublayer(playerLayer)
            guard let videoPlayer = videoPlayer else { return }
            videoPlayer.play()
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
                videoPlayer.seek(to: .zero)
                videoPlayer.play()
            }
        }
    }
    
    private func playSound() {
        if UIDevice.current.batteryState == .unplugged {
            guard let index = index else { return }
            guard let url = Bundle.main.url(forResource: trackName[index], withExtension: "mp3") else { return }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                guard let player = player else { return }
                player.numberOfLoops =  -1
                if UIDevice.current.batteryState != .unplugged && !Defaults.pluggedSoundHidden {
                    player.play()
                }
                
                if UIDevice.current.batteryState == .unplugged && !Defaults.soundHidden {
                    player.play()
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        } else if UIDevice.current.batteryState != .unplugged {
            guard let url = Bundle.main.url(forResource: trackName[Defaults.selectedAnimationIndex], withExtension: "mp3") else { return }

            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                guard let player = player else { return }
                player.numberOfLoops =  -1
                if UIDevice.current.batteryState != .unplugged && !Defaults.pluggedSoundHidden {
                    player.play()
                }

                if UIDevice.current.batteryState == .unplugged && !Defaults.soundHidden {
                    player.play()
                }

            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func getIndex(with item: Int) {
        index = item
    }
    
    private func setupGesture() {
        if Defaults.openPreview {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
            tap.numberOfTapsRequired = 1
            let videoTap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
            videoTap.numberOfTapsRequired = 1
            videoView.addGestureRecognizer(videoTap)
            animationView.addGestureRecognizer(tap)
        }
    }
    
    @objc func tapHandler(gesture: UITapGestureRecognizer) {
        Defaults.openPreview = false
        self.dismiss(animated: false)
    }
    
    private func setupTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { _ in
            self.observeBattery()
        })
    }
    
    private func setupDateAndTime() {
        dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
        timeLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
    }
    
    @objc func tick() {
        dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
        timeLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
    }
    
    private func observeBattery() {
        BatteryManager.shared.battery.observe(on: self) { battery in
            let text: String = battery.level == -1 ? "" : "\(Int(battery.level * 100))%"
            DispatchQueue.main.async {
                self.batteryLabel.text = text
            }
        }
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBakcground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBakcground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupNextScreen), name: UIDevice.batteryStateDidChangeNotification, object: nil)
    }
    
    @objc func appDidEnterBakcground() {
        self.animationView.pause()
        self.videoPlayer?.pause()
    }
    
    @objc func appWillEnterForeground() {
        self.animationView.play()
        self.videoPlayer?.play()
    }
    
    @objc func setupNextScreen() {
        if UIDevice.current.batteryState == .unplugged {
            Defaults.unpluggedLaunch = false
            let mainMenuController = MainMenuAssembly.shared.build()
            mainMenuController.modalPresentationStyle = .fullScreen
            present(mainMenuController, animated: false)
        }
    }
}
