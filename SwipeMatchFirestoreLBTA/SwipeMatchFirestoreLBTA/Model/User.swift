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
     var imgUrl2: String?
     var imgUrl3: String?
    var uid: String?
    
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    
    
  
    
    init(dictionary: [String:Any]) {
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
       self.name = dictionary["fullName"] as? String ?? ""
         self.imgUrl1 = dictionary["imgUrl1"] as? String 
         self.imgUrl2 = dictionary["imgUrl2"] as? String
         self.imgUrl3 = dictionary["imgUrl3"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int
        
       
//        self.imageNames = [imgUrl1]
        
        
    }
  
  func toCardViewModel() -> CardViewModel {
    
    
    let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
    
    let ageString = age != nil ? "\(age!)" : "N/A"
    
    
    
    attributedText.append(NSAttributedString(string: " \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .light)]))
    
    let professionString = profession != nil ? profession! : "Not available"
    
    attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
    
    var imgUrls = [String]() // empty string array
    
    if let url = imgUrl1 {imgUrls.append(url)}
    if let url = imgUrl2 {imgUrls.append(url)}
    if let url = imgUrl3 {imgUrls.append(url)}
    
    return CardViewModel(imgNames: imgUrls, attributedString: attributedText, textAlignment: .left)
  }
}
