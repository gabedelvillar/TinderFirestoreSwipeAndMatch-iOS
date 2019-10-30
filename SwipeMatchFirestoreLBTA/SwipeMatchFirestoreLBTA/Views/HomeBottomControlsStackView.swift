//
//  HomeBottomControlsStackView.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar on 9/19/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
    
    static func createButton(image: UIImage) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        return btn
    }
    
    let refreshBtn = createButton(image: #imageLiteral(resourceName: "refresh_circle"))
    let dislikeBtn = createButton(image: #imageLiteral(resourceName: "dismiss_circle"))
    let superLikeBtn = createButton(image: #imageLiteral(resourceName: "super_like_circle"))
    let likeBtn = createButton(image: #imageLiteral(resourceName: "like_circle"))
    let specialBtn = createButton(image: #imageLiteral(resourceName: "boost_circle"))

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    distribution = .fillEqually
    
    heightAnchor.constraint(equalToConstant: 100).isActive = true
    
    [refreshBtn, dislikeBtn, superLikeBtn, likeBtn, specialBtn].forEach { (btn) in
        self.addArrangedSubview(btn)
    }
    
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
