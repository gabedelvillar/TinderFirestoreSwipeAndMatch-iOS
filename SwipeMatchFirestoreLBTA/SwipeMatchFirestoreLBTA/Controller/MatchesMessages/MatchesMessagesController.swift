//
//  MatchesMessagesController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar De Santiago on 11/19/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import LBTATools
import Firebase



class RecentMessageCell: LBTAListCell<RecentMessages> {
    
    let userProfileImageView = UIImageView(image: #imageLiteral(resourceName: "kelly1"), contentMode: .scaleAspectFill)
    let userNameLabel = UILabel(text: "USERNAME HERE", font: .boldSystemFont(ofSize: 18))
    
    let messageTextLabel = UILabel(text: "Some long line of text that should span 2 lines", font: .systemFont(ofSize: 16), textColor: .gray, numberOfLines: 2)
    
    override var item: RecentMessages! {
        didSet {
            userNameLabel.text = item.name
            messageTextLabel.text = item.text
            userProfileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        
        userProfileImageView.layer.cornerRadius = 94 / 2
        
        
        hstack(userProfileImageView.withWidth(94).withHeight(94), stack(userNameLabel, messageTextLabel, spacing: 2), spacing: 20, alignment: .center).padLeft(20).padRight(20)
        
        
        addSeparatorView(leadingAnchor: userNameLabel.leadingAnchor)
    }
}

struct RecentMessages {
    let text, uid, name, profileImageUrl: String
    let timestamp: Timestamp
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ??
            Timestamp(date: Date())
    }
}


class MatchesMessagesController: LBTAListHeaderController<RecentMessageCell, RecentMessages, MatchesHeader>, UICollectionViewDelegateFlowLayout {
    
    fileprivate func fetchRecentMessages() {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("matches_messages").document(currentUserId).collection("recent_messages").addSnapshotListener { (querySnaphot, err) in
            if let err = err {
                print(err)
                return
            }
            
            querySnaphot?.documentChanges.forEach({ (change) in
                if change.type == .added {
                    let dictionary = change.document.data()
                    self.items.append(RecentMessages(dictionary: dictionary))
                }
            })
            
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func setupHeader (_ header: MatchesHeader) {
        header.matchesHorizontalController.rootMatchesController = self
    }
    
    
    func didSelectMatchFromHeader(match: Match){
        let chatLogController = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 250)
    }
    
    let customNavBar = MatchesNavBar()
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 140)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRecentMessages()
        
       
        setupUI()

    }
    
    fileprivate func setupUI() {
        collectionView.backgroundColor = .white
        
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .zero, size: .init(width: 0, height: 150))
        
        
        collectionView.contentInset.top = 150
        collectionView.scrollIndicatorInsets.top = 150
        
        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
}
