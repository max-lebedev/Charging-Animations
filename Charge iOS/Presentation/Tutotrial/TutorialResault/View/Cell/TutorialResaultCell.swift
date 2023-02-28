//
//  TutorialResaultCell.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 28.01.2022.
//

import UIKit

class TutorialResaultCell: UICollectionViewCell {
    
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
