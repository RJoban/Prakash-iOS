//
//  Extensions.swift
//  Prakash
//
//  Created by Ravi Jobanputra on 15/08/20.
//  Copyright © 2020 I. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setViewShadow_()
    {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: -2.0, height: 2.0)
        self.layer.shadowOpacity = 0.5;
    }
    func setViewShadow(clr : UIColor)
    {
        self.dropShadow(color: clr, opacity: 0.5, offSet: CGSize(width: -2, height: 2), radius: 5, scale: true)
    }
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        //   layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}
extension Sequence {
    
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
