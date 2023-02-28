//
//  MainMenuCell.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 13.01.2022.
//

import Foundation
import UIKit

class MainMenuCell: UICollectionViewCell {
    
    
    
    @IBOutlet var cellsBackgroundView: UIView!
    @IBOutlet var animationImage: UIImageView!
    @IBOutlet var checkImage: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayoutSubviews()
    }
    
    private func setupLayoutSubviews() {
        cellsBackgroundView.layer.cornerRadius = 15
        cellsBackgroundView.backgroundColor = .blue
        
        animationImage.layer.cornerRadius = 15
        
        cellsBackgroundView.layer.masksToBounds = false
        cellsBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cellsBackgroundView.layer.shadowColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
        cellsBackgroundView.layer.shadowOpacity = 1
        cellsBackgroundView.layer.shadowRadius = 4
        cellsBackgroundView.layer.cornerRadius = 15
    }
    
    func setup(with item: MainMenuModel) {
        animationImage.image = item.image
    }
    
}
