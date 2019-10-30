//
//  User.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar on 9/27/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import UIKit


struct User: ProducesCardViewModel {
  var name: String?
  var age: Int?
  var profession: String?
//  let imageNames: [String]
    var imgUrl1: String?
    var uid: String?
    
    
  
    
    init(dictionary: [String:Any]) {
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
       self.name = dictionary["fullName"] as? String ?? ""
         self.imgUrl1 = dictionary["imgUrl1"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
       
//        self.imageNames = [imgUrl1]
        
        
    }
  
  func toCardViewModel() -> CardViewModel {
    
    
    let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
    
    let ageString = age != nil ? "\(age!)" : "N/A"
    
    
    
    attributedText.append(NSAttributedString(string: " \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .light)]))
    
    let professionString = profession != nil ? profession! : "Not available"
    
    attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
    
    return CardViewModel(imgNames: [imgUrl1 ?? ""], attributedString: attributedText, textAlignment: .left)
  }
}
