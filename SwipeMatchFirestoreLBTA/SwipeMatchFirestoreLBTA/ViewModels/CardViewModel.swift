//
//  CardViewModel.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar on 9/27/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import UIKit

protocol ProducesCardViewModel {
  func toCardViewModel() -> CardViewModel
}

// View Model is suppose to represent the State of our view
class CardViewModel {
    let uid: String
  let imgUrls: [String]
  let attributedString: NSAttributedString
  let textAlignment: NSTextAlignment
  
    init(uid: String, imgNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment){
        self.uid = uid
    self.imgUrls = imgNames
    self.attributedString = attributedString
    self.textAlignment = textAlignment
  }
  
  fileprivate var imgIndex = 0 {
    didSet {
      let imgUrl = imgUrls[imgIndex]
//      let img = UIImage(named: imgName) ?? UIImage()
      
      imgIndexObserver?(imgIndex, imgUrl)
    }
  }
  
  // Reactive Programming
  var imgIndexObserver: ((Int,String) -> ())?
  
  func advanceToNextPhoto() {
    imgIndex = min(imgIndex + 1, imgUrls.count - 1)
  }
  
  func gotToPreviousPhoto() {
    imgIndex = max(0, imgIndex - 1)
  }
  
 
}
