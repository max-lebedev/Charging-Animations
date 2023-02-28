//
//  UIViewController + Extension.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 18.02.2022.
//

import Foundation

import UIKit

private var aView: UIView?

extension UIViewController {
    func showSpinner() {
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)

        let ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        ai.tintColor = .white
        ai.center = aView?.center ?? CGPoint(x: 0, y: 0)
        ai.startAnimating()
        aView?.addSubview(ai)
        
//        let loadingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 160, height: 30))
//        loadingLabel.center = CGPoint(x: aView?.center.x ?? 200, y: (aView?.center.y ?? 200) - 100)
//        loadingLabel.text = L10n.PhotoTypes.loading
//        loadingLabel.textAlignment = .center
//        loadingLabel.font = FontFamily.SFUIText.medium.font(size: 16)
//        loadingLabel.textColor = Asset.textColor.color
//        aView?.addSubview(loadingLabel)
        
        self.view.addSubview(aView ?? UIView())
    }

    func removeSpinner() {
        aView?.removeFromSuperview()
        aView = nil
    }
}
