//
//  User.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar on 9/27/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import UIKit


struct User: ProducesCardViewModel {
  let name: String
  let age: Int
  let profession: String
  let imageNames: [String]
  
  
  func toCardViewModel() -> CardViewModel {
    
    
    let attributedText = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
    
    attributedText.append(NSAttributedString(string: " \(age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .light)]))
    
    attributedText.append(NSAttributedString(string: "\n\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
    
    return CardViewModel(imgNames: imageNames, attributedString: attributedText, textAlignment: .left)
  }
}
