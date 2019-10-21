//
//  HomeBottomControlsStackView.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar on 9/19/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    distribution = .fillEqually
    
    heightAnchor.constraint(equalToConstant: 100).isActive = true
    
   let subViews = [ #imageLiteral(resourceName: "refresh_circle"), #imageLiteral(resourceName: "dismiss_circle"), #imageLiteral(resourceName: "super_like_circle"), #imageLiteral(resourceName: "like_circle"), #imageLiteral(resourceName: "boost_circle")].map { (img) -> UIView in
      let btn = UIButton(type: .system)
      btn.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
      return btn
    }
    
//    // bottom row of buttons
//    let bottomSubViews = [UIColor.red, .green, .blue, .yellow, .purple].map { (color) -> UIView in
//      let view = UIView()
//      view.backgroundColor = color
//      return view
//    }
    
    subViews.forEach { (view) in
      addArrangedSubview(view)
    }
    
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
