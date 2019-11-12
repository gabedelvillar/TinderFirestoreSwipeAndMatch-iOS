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
    bottomControls.likeBtn.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
    bottomControls.dislikeBtn.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
   
    setupLayout()
    fetchCurrentUser()
    
//    setupDummyCards()
//
//    fetchUsersFromFirestore()
    
 
  }
    
    var topCardView: CardView?
    
    @objc fileprivate func handleLike() {
        saveSwipeToFirestore(didLike: 1)
        performSwipeAnimation(translation: 700, angle: 15)
    }
    
    fileprivate func saveSwipeToFirestore(didLike: Int) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        guard let cardUID = topCardView?.cardViewModel.uid else {return}
        
       
        
        let documentData = [cardUID: didLike]
        
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
            if let err = err{
                print("Failed to fetch swipe document ", err)
                return
            }
            
            if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData) { (err) in
                    if let err = err{
                        print("Failed to update swipe data: ", err)
                        return
                    }
                    
                    print("Successfully updated swipe!..")
                    if didLike == 1 {
                        self.checkIfMatchExists(cardUID: cardUID)
                           }
                    
                }

            } else {
                Firestore.firestore().collection("swipes").document(uid).setData(documentData) { (err) in
                    if let err = err {
                        print("Failed to save swipe data: ", err)
                        return
                    }
                    
                    if didLike == 1 {
                        self.checkIfMatchExists(cardUID: cardUID)
                           }
                }

            }
        }
        
        
    }
    
    fileprivate func checkIfMatchExists(cardUID: String) {
        // How to detect match between two usersrs
        
        Firestore.firestore().collection("swipes").document(cardUID).getDocument
            {
                (snapshot, err) in
                if let err = err{
                    print("errir in fetching swipes: ", err)
                    return
                }
                
                guard let data = snapshot?.data() else {return}
                
                guard let uid = Auth.auth().currentUser?.uid else {return}
                
                let hasMatch = data[uid] as? Int == 1
                
                if hasMatch {
                    print("Has matched")
                    self.presentMatchView(cardUID: cardUID)
                }
        }
    }
    
    fileprivate func presentMatchView(cardUID: String) {
        let matchView = MatchView()
        
        view.addSubview(matchView)
        matchView.fillSuperview()
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
    fileprivate let hud = JGProgressHUD(style: .dark)
    
    fileprivate func fetchCurrentUser() {
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                print("Failed to fetch user: ", err)
                self.hud.dismiss()
            }
            
            self.user = user
            
            self.fetchSwipes()
            
//            self.fetchUsersFromFirestore()
            
        }
    }
    
    var swipes = [String: Int]()
    
    fileprivate func fetchSwipes() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
            if let err = err{
                print("Failed to fetch swipes for current user: ", err)
                return
            }
            
            guard let data = snapshot?.data() as? [String: Int] else {return}
            
            self.swipes = data
            self.fetchUsersFromFirestore()
        }
    }
    
    @objc fileprivate func handleRefresh(){
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        if topCardView == nil{
            fetchUsersFromFirestore()
            
        }
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
        
        topCardView = nil
            query.getDocuments { (snapshot, err) in
                hud.dismiss()
            
            if let err = err{
                print("Faile to get users", err)
                return
            }
            
                var previousCardView: CardView?
                
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
                let hasNotSwipedBefore = self.swipes[user.uid!] == nil
                
                if isNotCurrentUser && hasNotSwipedBefore {
                    let cardView = self.setupCardFromUser(user: user)
                    
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
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
    
    @objc fileprivate func handleDislike() {
        saveSwipeToFirestore(didLike: 0)
       performSwipeAnimation(translation: -700, angle: -15)
    }
    
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        let duration = 0.5
             
             let translationAnimation = CABasicAnimation(keyPath: "position.x")
             
             translationAnimation.toValue = translation
             
             translationAnimation.duration = duration
             translationAnimation.fillMode = .forwards
             translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
             translationAnimation.isRemovedOnCompletion = false
             
             let rotationanimation = CABasicAnimation(keyPath: "transform.rotation.z")
             
             rotationanimation.toValue = angle * CGFloat.pi / 180
             rotationanimation.duration = duration
             
             let cardView = topCardView
             topCardView = cardView?.nextCardView
             
             CATransaction.setCompletionBlock {
                 self.topCardView?.removeFromSuperview()
             }
             
             cardView?.layer.add(translationAnimation, forKey: "translation")
             cardView?.layer.add(rotationanimation, forKey: "rotation")
             CATransaction.commit()
    }
    
    
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    
    fileprivate func setupCardFromUser(user: User) -> CardView{
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
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

