//
//  Advertiser.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar on 9/28/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import UIKit


struct Advertiser: ProducesCardViewModel {
  let title: String
  let brandName: String
  let posterPhotoName: String
  
  
  func toCardViewModel() -> CardViewModel {
    
    let attributedString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
    
    attributedString.append(NSAttributedString(string: "\n" + brandName, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
    
    
    
    return CardViewModel(uid: "", imgNames: [posterPhotoName], attributedString: attributedString, textAlignment: .center)
  }
}
