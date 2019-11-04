//
//  RegistrationModel.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar on 10/5/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {
    
    var bindableIsRegistering = Bindable<Bool>()
    
    var bindableImg = Bindable<UIImage>()
    
    
//    var image: UIImage? {
//        didSet{
//            imageObserver?(image)
//        }
//    }
//
//    var imageObserver: ((UIImage?) -> ())?
    
  var fullName: String? {didSet {checkFromValididity()}}
  var email: String? {didSet {checkFromValididity()}}
  var password: String? {didSet{checkFromValididity()}}
    
    
    func checkFromValididity () {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && bindableImg.value != nil
      
      bindableIsFormValid.value = isFormValid
      
      //isFormValidObserver?(isFormValid)
      }
    
    
    func performRegistration(completion: @escaping (Error?)->()) {
        
        guard let email = email, let password = password else {return}
        bindableIsRegistering.value = true
      
            Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
                if let err = err {
                    print(err)
                    completion(err)
                    return
                }
                
                print("succssfully registered user", res?.user.uid ?? "")
                
                self.saveImgToFirebase(completion: completion)
                
                // Only upload images to Firebase Storage once you are authorized
       
                
                
                
            }
    }
    
    fileprivate func saveImgToFirebase(completion: @escaping (Error?) -> ()) {
        let filename = UUID().uuidString
               let ref = Storage.storage().reference(withPath: "/images/\(filename)")
               
               let imgData = self.bindableImg.value?.jpegData(compressionQuality: 0.75) ?? Data()
               
               ref.putData(imgData , metadata: nil, completion: { (_, err) in
                   if let err = err {
                       completion(err)
                       return
                   }
                   
                   print( "Finished uploading image to storage")
                   
                   ref.downloadURL { (url, err) in
                       if let err = err {
                           completion(err)
                           return
                       }
                      
                       self.bindableIsRegistering.value = false
                       print("Download url of our image is: ", url?.absoluteString ?? "")
                    
                    let imgUrl = url?.absoluteString ?? ""
                    
                    self.saveInfoToFirebase(imgUrl: imgUrl, completion: completion)
                   }
                   
                   
               })
    }
    
    fileprivate func saveInfoToFirebase(imgUrl: String, completion: @escaping (Error?) -> ()){
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData = [
            "fullName":fullName ?? "",
            "uid": uid,
            "imgUrl1":imgUrl,
            "age": 18,
            "minSeekingAge" : SettingsController.defaultMinSeekingAge,
            "maxSeekingAge" : SettingsController.defaultMaxSeekingAge
            ] as [String : Any]
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            if let err = err {
                completion(err)
                return
            }
            
            completion(nil)
        }
    }
  
 
    
    var bindableIsFormValid = Bindable<Bool>()
    
    
    
    
  // Reacitve Programming
//  var isFormValidObserver: ((Bool) -> ())?
}
