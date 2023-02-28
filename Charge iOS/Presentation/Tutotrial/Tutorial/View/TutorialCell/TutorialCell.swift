//
//  TutorialCell.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 27.01.2022.
//

import UIKit
import Lottie

class TutorialCell: UICollectionViewCell {
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var animatioView: AnimationView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        animatioView.contentMode = .scaleAspectFit
        animatioView.loopMode = .loop
        animatioView.animationSpeed = 0.4
        animatioView.play()
    }
    
    func setup(with item: TutorialModel) {
        imageView.image = item.image
        descriptionLabel.text = item.description
    }
}
