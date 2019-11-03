//
//  CardView.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar on 9/25/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel)
}

class CardView: UIView {
    
    var delegate: CardViewDelegate?
  
  var cardViewModel: CardViewModel! {
    didSet {
      let imgName = cardViewModel.imgUrls.first ?? ""
//      imgView.image = UIImage(named: imgName)
        // load our image using some kind of url instead
        
        if let url = URL(string: imgName){
            imgView.sd_setImage(with: url)
        }
        
      informationLbl.attributedText = cardViewModel.attributedString
      informationLbl.textAlignment = cardViewModel.textAlignment
      
      
      
      (0..<cardViewModel.imgUrls.count).forEach { (_) in
        let barView = UIView()
        barView.backgroundColor = barDeselectedColor
        barsStackView.addArrangedSubview(barView)
      }
      
      barsStackView.arrangedSubviews.first?.backgroundColor = .white
      
      setupImgIndexObserver()
      
    }
  }
  
  fileprivate func setupImgIndexObserver() {
    cardViewModel.imgIndexObserver = {[unowned self] (idx, imageUrl) in
      print("changing phow from view model")
        
        if let url = URL(string: imageUrl){
            self.imgView.sd_setImage(with: url)
        }
        
      
      
      self.barsStackView.arrangedSubviews.forEach({ (view) in
        view.backgroundColor = self.barDeselectedColor
        
      })
      
      self.barsStackView.arrangedSubviews[idx].backgroundColor = .white
      
    }
  }
  
  fileprivate let imgView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
  fileprivate let gradientLayer = CAGradientLayer()
  fileprivate let informationLbl = UILabel()
  
  // Configurations
  fileprivate let threshold: CGFloat = 100
  

  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
    
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    
    addGestureRecognizer(panGesture)
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
  }
  
  
  fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
  
  @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
    let tapLocation = gesture.location(in: nil)
    let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
    
    if shouldAdvanceNextPhoto {
      cardViewModel.advanceToNextPhoto()
    } else {
      cardViewModel.gotToPreviousPhoto()
    }
    
  }
    
    fileprivate let moreInfoBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func handleMoreInfo() {
        delegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
    }
  
  fileprivate func setupLayout() {
    layer.cornerRadius = 10
    clipsToBounds = true
    
   
    
    imgView.contentMode = .scaleAspectFill
    
    addSubview(imgView)
    imgView.fillSuperview()
    
     setupBarStackView()
    
    // add a gradient layer somehow
    
    setupGradientLayer()
    
    
    addSubview(informationLbl)
    informationLbl.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
    
    informationLbl.textColor = .white
    informationLbl.numberOfLines = 0
    
    addSubview(moreInfoBtn)
    moreInfoBtn.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 44, height: 44))
  }
  
  fileprivate let barsStackView = UIStackView()
  
  fileprivate func setupBarStackView() {
    addSubview(barsStackView)
    barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
    
    barsStackView.spacing = 4
    barsStackView.distribution = .fillEqually
    
   
  }
  
 
 
  
  fileprivate func setupGradientLayer() {
    // how can we draw a gradient with Swift
    
    
    gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
  
    gradientLayer.locations = [0.5, 1.1]
    
    layer.addSublayer(gradientLayer)
  }
  
  override func layoutSubviews() {
    // in here you know what your CardView frame will be
    gradientLayer.frame = self.frame
    
  }
  
  
  @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
  
    
    switch gesture.state {
      
    case .began:
      superview?.subviews.forEach({ (subview) in
        subview.layer.removeAllAnimations()
      })
      
    case .changed:
      handleChanged(gesture)
    case .ended:
      handleEnded(gesture)
    default:
      ()
    }
  }
  
  fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
    
    let translation = gesture.translation(in: nil)
    
    let degrees: CGFloat = translation.x / 20
    let angle = degrees * .pi / 180
    
    let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
    
    self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
  }
  
  fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
    
    
    
    
     let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
    
    let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
    
    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
      if shouldDismissCard {
        self.frame = CGRect(x: 600 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
      } else {
        self.transform = .identity
      }
      
    }) { (_) in
      self.transform = .identity
      
      if shouldDismissCard {
         self.removeFromSuperview()
      }
     
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  

}
