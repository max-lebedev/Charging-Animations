//
//  SettingsCell.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 22.01.2022.
//

import UIKit
import TableKit

class SettingsCell: UITableViewCell, ConfigurableCell {
    func configure(with model: (String, UIImage)) {
        settingsLabel.text = model.0
        settingsImage.image = model.1
    }
    
    typealias CellData = (String, UIImage)
    
    @IBOutlet var settingsLabel: UILabel!
    @IBOutlet var settingsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static var defaultHeight: CGFloat? {
        return 60
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

