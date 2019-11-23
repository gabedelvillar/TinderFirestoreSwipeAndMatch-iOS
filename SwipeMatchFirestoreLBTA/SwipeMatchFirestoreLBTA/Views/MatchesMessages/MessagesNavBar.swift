//
//  MessagesNavBar.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar De Santiago on 11/21/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import LBTATools


class MessagesNavBar: UIView {
    
    let userProfileImageView = CircularImageView(width: 44, image: #imageLiteral(resourceName: "kelly3"))
    
    let nameLable = UILabel(text: "USERNAME", font: .systemFont(ofSize: 16))
    
    let backButton = UIButton(image: UIImage(named: "back") ?? UIImage(), tintColor: #colorLiteral(red: 1, green: 0.364674747, blue: 0.3694452643, alpha: 1))
    let flagButton = UIButton(image: #imageLiteral(resourceName: "flag"), tintColor: #colorLiteral(red: 1, green: 0.364674747, blue: 0.3694452643, alpha: 1))
    
    
    fileprivate let match: Match
    
    init(match: Match) {
        self.match = match
        
        nameLable.text = match.name
        userProfileImageView.sd_setImage(with: URL(string: match.profileImageUrl))
   
        super.init(frame: .zero)
        
        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        
        let middleStack = hstack(
            stack(userProfileImageView, nameLable, spacing: 8, alignment: .center),
        alignment: .center
        )
        
        hstack(backButton.withWidth(50), middleStack, flagButton).withMargins(.init(top: 0, left: 4, bottom: 0, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
