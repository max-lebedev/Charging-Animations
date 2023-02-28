//
//  OnboardingViewVC.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 24.12.2021.
//

import UIKit
import SwiftyUserDefaults

class OnboardingViewController: UIViewController {
    
    // MARK: - Private properties
    private let onboardingCellIdentifier = "OnboardingCell"
    private var data: [OnboardingModel]?
    private var currentItem: Int = 0
    
    // MARK: - Public properties
        var presenter: OnboardingPresenterImpl?
    
    @IBOutlet private var continueButton: UIButton!
    @IBOutlet private var onboardingCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.loadData()
        setupOnboardingCollectionView()
        localize()
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        guard let data = data else { return }
        if currentItem == data.count - 1 {
            self.presenter?.onboardingSeen()
            setupNextScreen()
            return
        }
        currentItem += 1
        configureScrollAndPagin()
    }
    
    // MARK: - Private methods
    
    private func localize() {
        continueButton.setTitle(L10n.continue, for: .normal)
    }
    
    private func setupOnboardingCollectionView() {
        onboardingCollectionView.dataSource = self
        onboardingCollectionView.delegate = self
        onboardingCollectionView.register(UINib(nibName: onboardingCellIdentifier, bundle: nil), forCellWithReuseIdentifier: onboardingCellIdentifier)
        onboardingCollectionView.isScrollEnabled = false
    }
    
    private func configureScrollAndPagin() {
        onboardingCollectionView.isPagingEnabled = false
        onboardingCollectionView.scrollToItem(
            at: IndexPath(item: currentItem, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
        onboardingCollectionView.isPagingEnabled = true
    }
    
    private func setupNextScreen() {
        if UIDevice.current.batteryState != .unplugged {
            Defaults.unpluggedLaunch = false
            let storyboard = UIStoryboard(name: "ChargingAnimation", bundle: Bundle.main)
            let preview = storyboard.instantiateViewController(withIdentifier: "ChargingAnimationViewController") as! ChargingAnimationViewController
            preview.modalPresentationStyle = .fullScreen
            present(preview, animated: false)
        } else if UIDevice.current.batteryState == .unplugged {
            Defaults.unpluggedLaunch = true
            let mainMenuController = MainMenuAssembly.shared.build()
            mainMenuController.modalPresentationStyle = .fullScreen
            present(mainMenuController, animated: false)
        }
    }
}

// MARK: - OnboardingProtocol
extension OnboardingViewController: OnboardingProtocol {
    func setData(data: [OnboardingModel]) {
        self.data = data
    }
}

// MARK: - UICollectionViewDataSource
extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = data else { return 0 }
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currentItem = indexPath.item
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = onboardingCollectionView.dequeueReusableCell(
            withReuseIdentifier: onboardingCellIdentifier,
            for: indexPath
        ) as? OnboardingCell else {
            return UICollectionViewCell()
        }
        if let data = data {
            let item = data[indexPath.item]
            cell.setup(with: item)
        }
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
