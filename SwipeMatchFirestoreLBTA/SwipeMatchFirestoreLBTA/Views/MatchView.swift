//
//  MatchView.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar De Santiago on 11/12/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import UIKit
import Firebase

class MatchView: UIView {
    
    var currentUser: User! {
        didSet{
            
           
        }
    }
    
    // you're almost always guranteed to have this variable set up
    var cardUID: String! {
        didSet{
            
            // either fetch current user inside here or pass in our current user if we have it
            
            // fetch the cardUID information
            
            let query  =  Firestore.firestore().collection("users")
            
           query.document(cardUID).getDocument { (snapshot, err) in
                if let err = err {
                    print("Failed to fetch card user", err)
                    
                    return
                }
                
                guard let dictionary = snapshot?.data() else {return}
                
                let user = User(dictionary: dictionary)
                
                guard let url = URL(string: user.imgUrl1 ?? "") else {return}
            
                self.cardUserImageView.sd_setImage(with: url)
            
            guard let currentUserImageUrl = URL(string: self.currentUser.imgUrl1 ?? "") else {return}
            
            self.currentUserImageView.sd_setImage(with: currentUserImageUrl) { (_, _, _, _) in
                self.setupAnimations()
            }
            
            }
        }
    }
    
    fileprivate let itsAMatchImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    fileprivate let descriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "You and X have liked\n each other"
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    fileprivate let currentUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly2"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    fileprivate let cardUserImageView: UIImageView = {
           let imageView = UIImageView(image: #imageLiteral(resourceName: "lady4c"))
           imageView.contentMode = .scaleAspectFill
           imageView.clipsToBounds = true
           imageView.layer.borderWidth = 2
           imageView.layer.borderColor = UIColor.white.cgColor
        imageView.alpha = 0
           return imageView
       }()
    
    fileprivate let sendMessageButton: UIButton = {
        let btn = SendMessageButton(type: .system)
        btn.setTitle("SEND MESSAGE", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    fileprivate let keepSwipingButton: UIButton = {
        let btn = KeepSwipingButton(type: .system)
        btn.setTitle("Keep Swiping", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBlurView()
        setupLayout()
    }
    
    fileprivate func setupAnimations() {
        
        views.forEach({$0.alpha = 1})
        
        // starting positions
        
        let angle = 30 * CGFloat.pi / 180
        
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        
        cardUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        
        sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        keepSwipingButton.transform = CGAffineTransform(translationX: 500, y: 0)
        
        // keyfarame animatoins for segmented animation
        
        
        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {
            
            
            // animation 1 - translation back to original position
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.cardUserImageView.transform = CGAffineTransform(rotationAngle: angle)
            }
            
            // animation 2 - rotation
            UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.3, animations: {
                self.currentUserImageView.transform = .identity
                self.cardUserImageView.transform = .identity
                
                self.sendMessageButton.transform = .identity
                self.keepSwipingButton.transform = .identity
            })
            
            
        }) { (_) in
            
        }
        
        
        UIView.animate(withDuration: 0.6, delay: 0.6 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.keepSwipingButton.transform = .identity
            self.sendMessageButton.transform = .identity
        })
    }
    
    lazy var views = [
        itsAMatchImageView,
        descriptionLbl,
        currentUserImageView,
        cardUserImageView,
        sendMessageButton,
        keepSwipingButton
    ]
    
    fileprivate func setupLayout() {
        views.forEach { (v) in
            addSubview(v)
            v.alpha = 0
        }
        
        let imageWidth: CGFloat = 140
        
        itsAMatchImageView.anchor(top: nil, leading: nil, bottom: descriptionLbl.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 300, height: 80))
        
        itsAMatchImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        descriptionLbl.anchor(top: nil, leading: leadingAnchor, bottom: currentUserImageView.topAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 32, right: 0), size: .init(width: 0, height: 50))
        
        currentUserImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: imageWidth, height: imageWidth))
        currentUserImageView.layer.cornerRadius = imageWidth / 2
        currentUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        cardUserImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: imageWidth, height: imageWidth))
        
        currentUserImageView.layer.cornerRadius = imageWidth / 2
               currentUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 60))
        
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, leading: sendMessageButton.leadingAnchor, bottom: nil, trailing: sendMessageButton.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0 , height: 60))
        
        
    }
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    fileprivate func setupBlurView() {
        
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 1
        }) { (_) in
            
        }
    }
    
    @objc fileprivate func handleTapDismiss() {
       
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 0
               }) { (_) in
                self.removeFromSuperview()
               }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
