//
//  UIButton + Extensions.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 02.02.2022.
//

import Foundation
import UIKit

extension UIButton {
    
    convenience init(title: String,
                     font: UIFont? = .robotoB18()) {
        self.init(type: .system)
        
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = font
        
    }
    
}

