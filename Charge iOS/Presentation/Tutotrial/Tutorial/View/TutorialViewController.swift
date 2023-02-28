//
//  TutorialViewController.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 27.01.2022.
//

import UIKit
import SwiftyUserDefaults

class TutorialViewController: UIViewController {
    
    // MARK: - Private properties
    private let tutorialCellIdentifier = "TutorialCell"
    private var data: [TutorialModel]?
    private var currentItem: Int = 0 {
        didSet {
            pageControl.currentPage = currentItem
        }
    }
    
    // MARK: - Public properties
    var presenter: TutorialPresenterImpl?
    
    // MARK: - @IBOutlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var openShortcutsButton: UIButton!
    @IBOutlet var pageControl: CustomPageControl!
    @IBOutlet var doesntWorkLabel: UILabel!
    @IBOutlet var laterButton: UIButton!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.loadData()
        setupOnboardingCollectionView()
        setupGesture()
        setupLabel()
        addNotification()
        localize()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupPageControl()
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        Defaults.needOpenInterstitial = true
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func openShortcutsButtonTapped(_ sender: UIButton) {
        openApp("shortcuts://")
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let data = data else { return }
        if currentItem == data.count - 1 {
            //            setupNextScreen()
            return
        }
        currentItem += 1
        configureScrollAndPagin()
        setupUI()
    }
    
    @IBAction func laterButtonTapped(_ sender: UIButton) {
        Defaults.needOpenInterstitial = true
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    private func setupOnboardingCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: tutorialCellIdentifier, bundle: nil), forCellWithReuseIdentifier: tutorialCellIdentifier)
        collectionView.isScrollEnabled = false
    }
    
    private func setupPageControl() {
        pageControl.isEnabled = false
        
        
    }
    
    private func localize() {
        openShortcutsButton.setTitle(L10n.openShortcuts,for:.normal)
        laterButton.setTitle(L10n.ready,for:.normal)
    }
    
    private func setupLabel() {
        doesntWorkLabel.attributedText = NSAttributedString(string: L10n.dosntWork, attributes:
                                                                [.underlineStyle: NSUnderlineStyle.single.rawValue])
        
    }
    
    private func configureScrollAndPagin() {
        collectionView.isPagingEnabled = false
        collectionView.scrollToItem(
            at: IndexPath(item: currentItem, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
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
    
    private func setupUI() {
        if currentItem == 4 {
            openShortcutsButton.isHidden = true
            doesntWorkLabel.isHidden = true
            nextButton.isHidden = true
            laterButton.isHidden = false
        } else {
            openShortcutsButton.isHidden = false
            doesntWorkLabel.isHidden = false
            nextButton.isHidden = false
            laterButton.isHidden = true
        }
    }
    
    private func setupGesture() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwiped))
        swipeRight.direction = .right
        self.collectionView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(leftSwiped))
        swipeLeft.direction = .left
        self.collectionView.addGestureRecognizer(swipeLeft)
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.doesntWorkLabel.isUserInteractionEnabled = true
        self.doesntWorkLabel.addGestureRecognizer(labelTap)
    }
    
    @objc
    func rightSwiped() {
        if self.currentItem >= 1 {
            self.collectionView.scrollToItem(
                at: IndexPath(item: currentItem - 1, section: 0),
                at: .centeredHorizontally,
                animated: true
            )
            currentItem -= 1
        }
        setupUI()
    }
    
    @objc
    func leftSwiped() {
        if 0 ..< 4 ~= currentItem {
            self.collectionView.scrollToItem(
                at: IndexPath(item: currentItem + 1, section: 0),
                at: .centeredHorizontally,
                animated: true
            )
            currentItem += 1
        }
        setupUI()
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {

        currentItem = 0
        configureScrollAndPagin()
        
        let storyboard = UIStoryboard(name: "DoesntWork", bundle: Bundle.main)
        let help = storyboard.instantiateViewController(withIdentifier: "DoesntWorkViewController") as! DoesntWorkViewController
        self.present(help, animated: true)
    }
    
}

// MARK: - OnboardingProtocol
extension TutorialViewController: TutorialProtocol {
    func setData(data: [TutorialModel]) {
        self.data = data
    }
}

// MARK: - UICollectionViewDataSource
extension TutorialViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = data else { return 0 }
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currentItem = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: tutorialCellIdentifier,
            for: indexPath
        ) as? TutorialCell else {
            return UICollectionViewCell()
        }
        if let data = data {
            let item = data[indexPath.item]
            cell.setup(with: item)
        }
        
        if indexPath.row == 4 {
            cell.imageView.isHidden = true
            cell.animatioView.isHidden = false
        } else {
            cell.imageView.isHidden = false
            cell.animatioView.isHidden = true
        }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(collectionView.contentOffset.x) / Int(collectionView.frame.width)
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

// MARK: - UICollectionViewDelegate
extension TutorialViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
