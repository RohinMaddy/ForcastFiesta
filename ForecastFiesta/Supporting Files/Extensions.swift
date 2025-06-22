//
//  Extensions.swift
//  ForecastFiesta
//
//  Created by Rohin Madhavan on 22/06/2025.
//

import UIKit


extension UIView {
    func addBlur(style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurView)
    }
    
    func roundCorners(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
