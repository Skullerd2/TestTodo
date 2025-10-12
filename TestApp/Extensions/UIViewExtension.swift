//
//  UIViewExtension.swift
//  TestApp
//
//  Created by Vadim on 12.10.2025.
//

import UIKit

extension UIView {
    func roundBottomCorners(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.masksToBounds = true
    }
}
