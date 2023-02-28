//
//  OnboardingCell.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 27.12.2021.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(with item: OnboardingModel) {
        imageView.image = item.image
        titleLabel.text = item.titleText
        descriptionLabel.text = item.descriptionText
    }
}
