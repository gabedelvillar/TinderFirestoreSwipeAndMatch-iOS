//
//  UserDetailsController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar De Santiago on 11/3/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import UIKit
import SDWebImage

class UserDetailsController: UIViewController, UIScrollViewDelegate {
    
    // you should really create a different ViewModel object for UserDetails
    // i.e UserDetailsaViewModel
    
    var cardViewModel: CardViewModel! {
        didSet {
            infoLbl.attributedText = cardViewModel.attributedString
            
            guard let firstImageUrl = cardViewModel.imgUrls.first, let url = URL(string: firstImageUrl) else {return}
            
            imageView.sd_setImage(with: url)
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    
    let imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "jane1"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let infoLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "User name 30\nDoctor\nSome bio text below"
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let dismissBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return btn
    }()

    fileprivate func createBtn(image: UIImage, selector: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: selector, for: .touchUpInside)
        btn.contentMode = .scaleAspectFill
        return btn
    }
    
    lazy var dislikeBtn = self.createBtn(image: #imageLiteral(resourceName: "dismiss_circle"), selector: #selector(handleDislike))
    lazy var superLikeBtn = self.createBtn(image: #imageLiteral(resourceName: "super_like_circle"), selector: #selector(handleDislike))
    lazy var likeBtn = self.createBtn(image: #imageLiteral(resourceName: "like_circle"), selector: #selector(handleDislike))
    
    @objc fileprivate func handleDislike() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupLayout()
        setupVisualBlurEffectView()
    }
    
    fileprivate func setupBottomControlls() {
        let stackView = UIStackView(arrangedSubviews: [dislikeBtn, superLikeBtn, likeBtn])
        stackView.distribution = .fillEqually
        stackView.spacing = -32
        view.addSubview(stackView)
        
        stackView.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 80))
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupVisualBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .regular)
        
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func setupLayout() {
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        scrollView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        scrollView.addSubview(infoLbl)
        infoLbl.anchor(top: imageView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 15))
        
        scrollView.addSubview(dismissBtn)
        
        dismissBtn.anchor(top: imageView.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: -25, left: 0, bottom: 0, right: 25), size: .init(width: 50, height: 50))
    }
    
    @objc fileprivate func handleDismiss() {
        dismiss(animated: true)
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        var width = view.frame.width + changeY * 2
        width = max(view.frame.width, width)
        imageView.frame = CGRect(x: min(0, -changeY), y: min(0, -changeY), width: width , height: width)
    }

}
