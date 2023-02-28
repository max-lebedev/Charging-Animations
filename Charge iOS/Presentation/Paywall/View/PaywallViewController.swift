//
//  PaywallViewController.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 10.01.2022.
//

import Foundation
import UIKit
import SwiftyUserDefaults

class PaywallViewController: UIViewController {
    
    private let cellIdentifier = "PaywallCell"
    private var selectedCellIndexPath: IndexPath = [0, 1]
    private let fullPrice = Defaults.yearlyPrice
    
    @IBOutlet private var premiumSubscriptionLabel: UILabel!
    @IBOutlet private var noAdsTitleLabel: UILabel!
    @IBOutlet private var noAdsTextLabel: UILabel!
    @IBOutlet private var prioritySupportTitleLabel: UILabel!
    @IBOutlet private var prioritySupportTextLabel: UILabel!
    @IBOutlet private var earlyUpdateTitleLabel: UILabel!
    @IBOutlet private var startTrialButtonLabel: UIButton!
    @IBOutlet private var earlyUpdateTextLabel: UILabel!
    @IBOutlet private var privacyPolicy: UIButton!
    @IBOutlet private var restorePurchase: UIButton!
    @IBOutlet private var termsOfUse: UIButton!
    @IBOutlet private var paywallCollectionView: UICollectionView!
    
    var subscriptions: [Subscription] = [
        Subscription(period: L10n.perMonth, totalPrice: Defaults.montlyPrice ?? String(), price: Defaults.montlyPrice ?? String(), perPeriod: L10n.perMonth),
        Subscription(period: L10n.per3Month, totalPrice: Defaults.yearlyPrice ?? String(), price: Defaults.montlyPrice ?? String(), perPeriod: L10n.perMonth)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        localize()
        addNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let indexPath = IndexPath(row: 1, section: 0)
        paywallCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
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
    
    @IBAction func crossButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    @IBAction func privacyPolicyButtonPressed(_ sender: UIButton) {
        if let url = URL(string: Keys.privacyPolicyUrl) {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func startTrialButton(_ sender: UIButton) {
        self.showSpinner()
        switch selectedCellIndexPath {
        case [0, 0]:
            print("SELECTED FIRST SUB")
            SubscriptionManager.instance.purchaseMonthlySubscription { purchased in
                switch purchased {
                case true:
                    self.removeSpinner()
                    self.navigationController?.popViewController(animated: true)
                case false:
                    self.removeSpinner()
                    
                }
            }
        case [0, 1]:
            print("SELECTED Second SUB")
            SubscriptionManager.instance.purchaseYearlySubscription { purchased in
                switch purchased {
                case true:
                    self.removeSpinner()
                    self.navigationController?.popViewController(animated: true)
                case false:
                    self.removeSpinner()
                    
                }
            }
        default :
            print("SELECTED DEFAULT SUB")
            self.removeSpinner()
        }
    }
    
    @IBAction func restorePerchaseButtonPressed(_ sender: UIButton) {
        SubscriptionManager.instance.restorePurchases { sucessful in
            if sucessful {
                let alert = UIAlertController(
                    title: L10n.Paywall.Alert.Sucess.title,
                    message: L10n.Paywall.Alert.Sucess.subtitle,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: L10n.ok, style: .default))
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(
                    title: L10n.Paywall.Alert.Failure.title,
                    message: L10n.Paywall.Alert.Failure.subtitle,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: L10n.ok, style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func termsOfUseButtonPressed(_ sender: UIButton) {
        if let url = URL(string: Keys.termsOfUseUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    
    private func setupCollectionView() {
        paywallCollectionView.dataSource = self
        paywallCollectionView.delegate = self
        paywallCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func localize() {
        premiumSubscriptionLabel.text = L10n.premiumSubscription
        noAdsTextLabel.text = L10n.firstSubAdvInfo
        noAdsTitleLabel.text = L10n.firstSubAdv
        prioritySupportTitleLabel.text = L10n.secondSubAdv
        prioritySupportTextLabel.text = L10n.secondSubAdvInfo
        earlyUpdateTitleLabel.text = L10n.thirdSubAdv
        earlyUpdateTextLabel.text = L10n.thirdSubAdvInfo
        startTrialButtonLabel.setTitle(L10n.startWith3DaysTrial,for:.normal)
    }
    
}

extension PaywallViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subscriptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath
        ) as? PaywallCell else {
            return UICollectionViewCell()
        }
        if indexPath.row == 0 {
            cell.periodLabel.text = L10n.perMonth
            collectionView.layer.masksToBounds = false
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = false
            cell.cellsBackgroundView.layer.masksToBounds = false
            cell.cellsBackgroundView.layer.cornerRadius = 10
        }
        if indexPath.row == 1 {
            cell.periodLabel.text = L10n.per3Month
            cell.perPeriodLabel.text = L10n.perMonth
            cell.saleLabel.text = L10n.sale
            cell.saleLabel.isHidden = false
        } else {
            cell.priceLabel.isHidden = true
            cell.perPeriodLabel.isHidden = true
        }
        cell.setup(with: subscriptions[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCellIndexPath = indexPath
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 1
        let numberOfCells: CGFloat = CGFloat(2)
        //        let numberOfCells: CGFloat = CGFloat(subscriptions.count)
        let spaceBetweenCells: CGFloat = 12
        let width = (paywallCollectionView.frame.width - (numberOfItemsPerRow - 1)) / numberOfItemsPerRow
        let height = (paywallCollectionView.frame.height - (spaceBetweenCells * (numberOfCells - 1))) / numberOfCells
        let size = CGSize(width: width, height: height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
