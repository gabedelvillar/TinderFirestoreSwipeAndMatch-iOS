//
//  SwipingPhotosController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar De Santiago on 11/3/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import UIKit

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var cardViewModel: CardViewModel! {
        didSet{
            controllers = cardViewModel.imgUrls.map({ (imageUrl) -> UIViewController in
                let photoController = PhotoController(imageUrl: imageUrl)
                
                return photoController
            })
            
            guard let firtElement = controllers.first else {return}
            
            setViewControllers([firtElement], direction: .forward, animated: false)
            
            setupBarViews()
        }
    }
    
    fileprivate let barsStackView = UIStackView(arrangedSubviews: [])
    fileprivate let deselectBarColor = UIColor(white: 0, alpha: 0.1)
    
    fileprivate func setupBarViews() {
        cardViewModel.imgUrls.forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = deselectBarColor
            barView.layer.cornerRadius = 2
            barView.clipsToBounds = true
            barsStackView.addArrangedSubview(barView)
        }
        barsStackView.arrangedSubviews.first?.backgroundColor = .white
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        view.addSubview(barsStackView)
        
        var paddingTop: CGFloat = 8
        
        if !isCardViewMode{
            paddingTop += UIApplication.shared.statusBarFrame.height
        }
//        let paddingTop =  + 8
        barsStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: paddingTop, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPhotoController = viewControllers?.first
        if let index = controllers.firstIndex(where: {$0 == currentPhotoController}) {
            barsStackView.arrangedSubviews.forEach({$0.backgroundColor = deselectBarColor})
            barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    
    var controllers = [UIViewController]()
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 {return nil}
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == controllers.count - 1 {return nil}
        return controllers[index + 1]
        
    }
    
    fileprivate let isCardViewMode: Bool
    
    init(isCardViewMode: Bool = false) {
        self.isCardViewMode = isCardViewMode
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        view.backgroundColor = .white
        self.delegate = self
        
        if isCardViewMode {
            disableSwipingAbility()
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let currentController = viewControllers!.first!
        if let index = controllers.firstIndex(of: currentController) {
            
            barsStackView.arrangedSubviews.forEach({$0.backgroundColor = deselectBarColor})
            
            if gesture.location(in: view).x > view.frame.width / 2 {

                let nextIndex = min(index + 1, controllers.count - 1)
                let nextController = controllers[nextIndex]
                setViewControllers([nextController], direction: .forward, animated: false)
                
                barsStackView.arrangedSubviews[nextIndex].backgroundColor = .white
            } else{

                let prevIndex = max(0, index - 1)
                let prevController = controllers[prevIndex]
                setViewControllers([prevController], direction: .forward, animated: false)
               
                barsStackView.arrangedSubviews[prevIndex].backgroundColor = .white
            }
            
        }
        
        
    }
    
    fileprivate func disableSwipingAbility() {
        view.subviews.forEach { (v) in
            if let v = v as? UIScrollView {
                v.isScrollEnabled = false
            }
        }
    }
 
}

class PhotoController: UIViewController {
    let imgView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    
    init(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            imgView.sd_setImage(with: url)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.addSubview(imgView)
        imgView.fillSuperview()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
    }
    
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}
