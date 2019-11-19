//
//  KeepSwipingButton.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar De Santiago on 11/13/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import UIKit

class KeepSwipingButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
               let leftColor = #colorLiteral(red: 0.9878463149, green: 0.1340239942, blue: 0.4606379867, alpha: 1)
               let rightColor = #colorLiteral(red: 0.9894919991, green: 0.3946856856, blue: 0.3105081916, alpha: 1)
               gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
               gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
               gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let cornerRadius = rect.height / 2
        
        let maskLayer = CAShapeLayer()
        
        let maskPath = CGMutablePath()
        
        maskPath.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath)
        
        maskPath.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 2, dy: 2), cornerRadius: cornerRadius).cgPath)
        
        maskLayer.path = maskPath
        
        maskLayer.fillRule = .evenOdd
        
        gradientLayer.mask = maskLayer
        
        self.layer.insertSublayer(gradientLayer, at: 0)
               layer.cornerRadius = cornerRadius
               clipsToBounds = true
               
               gradientLayer.frame = rect
    }

}
