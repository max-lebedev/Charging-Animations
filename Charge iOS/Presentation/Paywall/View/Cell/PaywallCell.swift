//
//  PaywallCell.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 10.01.2022.
//

import UIKit

class PaywallCell: UICollectionViewCell {
    
    @IBOutlet var cellsBackgroundView: UIView!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var perPeriodLabel: UILabel!
    @IBOutlet var periodLabel: UILabel!
    @IBOutlet var saleLabel: UILabel!
    @IBOutlet var checkDot: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellsBackgroundView.layer.cornerRadius = 10
        saleLabel.layer.cornerRadius = 5
        saleLabel.layer.masksToBounds = true
        reload()
    }
    
    func setup(with subscription: Subscription) {
        periodLabel.text = subscription.period
        totalPriceLabel.text = subscription.totalPrice
        priceLabel.text = subscription.price
        perPeriodLabel.text = subscription.perPeriod
    }

    func reload() {
        if isSelected {
            cellsBackgroundView.layer.borderWidth = 1
            cellsBackgroundView.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
            checkDot.isHidden = false
        } else {
            cellsBackgroundView.layer.borderWidth = 0
            checkDot.isHidden = true
        }
    }
}
