//
//  ViewController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar on 9/19/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController {
  
  let topStackView = TopNavigationStackView()
   let cardsDeckView = UIView()
  let bottomControls = HomeBottomControlsStackView()
  
//  let cardViewModels: [CardViewModel] = {
//    let producers = [
//      User(name: "Kelly", age: 23, profession: "Music DJ", imageNames: ["kelly1", "kelly2", "kelly3"]),
//    User(name: "Jane", age: 18, profession: "Teacher", imageNames: ["jane1", "jane2", "jane3"]),
//    Advertiser(title: "Slide Out Menu", brandName: "Lets Build That App", posterPhotoName: "slide_out_menu_poster")
//    ] as [ProducesCardViewModel]
//
//    let viewModels = producers.map({return $0.toCardViewModel()})
//    return viewModels
//  }()

    var cardViewModels = [CardViewModel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
    bottomControls.refreshBtn.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
   
    setupLayout()
    
    setupDummyCards()
    
    fetchUsersFromFirestore()
 
  }
    
    @objc fileprivate func handleRefresh(){
        fetchUsersFromFirestore()
    }
    
    var lastfetchUser: User?
    
    
    fileprivate func fetchUsersFromFirestore(){
        
        // intoduction of pagination
        
        let hud = JGProgressHUD(style: .dark)
        
        hud.textLabel.text = "Fetching Users"
        hud.show(in: self.view)
        
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastfetchUser?.uid] ?? [""]).limit(to: 2)
        
            query.getDocuments { (snapshot, err) in
                hud.dismiss()
            
            if let err = err{
                print("Faile to get users", err)
                return
            }
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastfetchUser = user
                self.setupUserFromCard(user: user)
               
            })
            
        }
    }
    
    fileprivate func setupUserFromCard(user: User){
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
  
  @objc fileprivate func handleSettings(){
    
    let registrationController = RegistrationController()
    
    present(registrationController, animated: true)
  }
  
  fileprivate func setupDummyCards(){

    cardViewModels.forEach { (cardVM) in
      let cardView = CardView(frame: .zero)
      
      cardView.cardViewModel = cardVM
      cardsDeckView.addSubview(cardView)
      cardView.fillSuperview()
    }
  }
  
  // MARK:- Fileprivate
  
  fileprivate func setupLayout() {
    view.backgroundColor = .white
    let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
    
    overallStackView.axis = .vertical
    
    view.addSubview(overallStackView)
    
    overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    
    overallStackView.isLayoutMarginsRelativeArrangement = true
    overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
    
    overallStackView.bringSubviewToFront(cardsDeckView)
  }


}

