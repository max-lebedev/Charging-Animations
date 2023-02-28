//
//  CustomPageControl.swift
//  Charge iOS
//
//  Created by Максим Лебедев on 28.01.2022.
//

import UIKit

//class CustomPageControl: UIPageControl {
//
//    override var numberOfPages: Int {
//        didSet {
//            updateIndicators()
//        }
//    }
//
//    override var currentPage: Int {
//        didSet {
//            updateIndicators()
//        }
//    }
//
//    private func updateIndicators() {
//        var indicators: [UIView] = []
//
//        if #available(iOS 14.0, *) {
//            indicators = subviews.first?.subviews.first?.subviews ?? []
//        } else {
//            indicators = subviews
//        }
//
//        for (index, indicator) in indicators.enumerated() {
//            let image = currentPage == index ? Asset.currentDot.image : Asset.dot.image
//            if let dot = indicator as? UIImageView {
//                dot.image = image
//
//            } else {
//                let imageView = UIImageView(image: image)
//                indicator.addSubview(imageView)
//            }
//        }
//    }
//}

class CustomPageControl: UIPageControl {
    
    let locationArrow: UIImage = Asset.currentDot.image
    let pageCircle: UIImage = Asset.dot.image
    
    override var numberOfPages: Int {
        didSet {
            updateDots()
        }
    }
    
    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pageIndicatorTintColor = UIColor.clear
        self.currentPageIndicatorTintColor = UIColor.clear
        self.clipsToBounds = false
    }
    
    func updateDots() {
        var i = 0
        for view in self.subviews {
            var imageView = self.imageView(forSubview: view)
            if imageView == nil {
                if i == 0 {
                    imageView = UIImageView(image: locationArrow)
                } else {
                    imageView = UIImageView(image: pageCircle)
                }
                imageView!.center = view.center
                view.addSubview(imageView!)
                view.clipsToBounds = false
            }
            if i == self.currentPage {
                imageView!.alpha = 1.0
            } else {
                imageView!.alpha = 0.5
            }
            i += 1
        }
    }
    
    fileprivate func imageView(forSubview view: UIView) -> UIImageView? {
        var dot: UIImageView?
        if let dotImageView = view as? UIImageView {
            dot = dotImageView
        } else {
            for foundView in view.subviews {
                if let imageView = foundView as? UIImageView {
                    dot = imageView
                    break
                }
            }
        }
        return dot
    }
}

