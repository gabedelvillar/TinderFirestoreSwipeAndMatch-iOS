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

class HomeController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {
  
  
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
    fetchCurrentUser()
    
//    setupDummyCards()
//
//    fetchUsersFromFirestore()
    
 
  }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
            let loginController = LoginController()
            loginController.delegate = self
            
            let navController = UINavigationController(rootViewController: loginController)
            present(navController, animated: true)
        }
        
       
    }
    
    func didFinishLogingIn() {
        fetchCurrentUser()
    }
    
    fileprivate var user: User?
    
    fileprivate func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err{
                print(err)
                return
            }
            
            guard let dicrionary = snapshot?.data() else {return}
            
            self.user = User(dictionary: dicrionary)
            self.fetchUsersFromFirestore()
        }
    }
    
    @objc fileprivate func handleRefresh(){
        fetchUsersFromFirestore()
    }
    
    var lastfetchUser: User?
    
    
    fileprivate func fetchUsersFromFirestore(){
//        guard let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge else {return}
        // intoduction of pagination
        
        let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
        
        let hud = JGProgressHUD(style: .dark)
        
        hud.textLabel.text = "Fetching Users"
        hud.show(in: self.view)
        
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        
            query.getDocuments { (snapshot, err) in
                hud.dismiss()
            
            if let err = err{
                print("Faile to get users", err)
                return
            }
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                
                if user.uid != Auth.auth().currentUser?.uid {
                    self.setupCardFromUser(user: user)
                }
                
//                self.cardViewModels.append(user.toCardViewModel())
//                self.lastfetchUser = user
               
               
            })
            
        }
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let userDetailsController = UserDetailsController()
        present(userDetailsController, animated: true)
    }
    
    fileprivate func setupCardFromUser(user: User){
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
  
  @objc fileprivate func handleSettings(){
    
    let settingsController = SettingsController()
    settingsController.delegate = self
    let navigationControlller = UINavigationController(rootViewController: settingsController)
    
    present(navigationControlller, animated: true)
  }
  
  fileprivate func setupDummyCards(){

    cardViewModels.forEach { (cardVM) in
      let cardView = CardView(frame: .zero)
      
      cardView.cardViewModel = cardVM
      cardsDeckView.addSubview(cardView)
      cardView.fillSuperview()
    }
  }

func didSaveSettings() {
      fetchCurrentUser()
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

