//
//  RegistrationViewModel.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar on 10/5/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import UIKit

class RegistrationViewModel {
  var fullName: String? {didSet {checkFromValididity()}}
  var email: String? {didSet {checkFromValididity()}}
  var password: String? {didSet{checkFromValididity()}}
  
  fileprivate func checkFromValididity () {
    let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
    
    isFormValidObserver?(isFormValid)
    }
  
  // Reacitve Programming
  var isFormValidObserver: ((Bool) -> ())?
}
