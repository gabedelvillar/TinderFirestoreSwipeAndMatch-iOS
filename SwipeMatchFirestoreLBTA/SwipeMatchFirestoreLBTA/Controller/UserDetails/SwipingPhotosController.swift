//
//  SwipingPhotosController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar De Santiago on 11/3/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import UIKit

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource {
    
    let controllers = [
        PhotoController(image:  imageLiteral(resourceName: "jane3")),
        PhotoController(image:  imageLiteral(resourceName: "jane3")),
        PhotoController(image:  imageLiteral(resourceName: "jane3")),
        PhotoController(image:  imageLiteral(resourceName: "jane3"))
    ]
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        setViewControllers([controllers.first!], direction: .forward, animated: false)
    }
    

 
}

class PhotoController: UIViewController {
    let imgView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    
    init(image: UIImage) {
        imgView.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.addSubview(imgView)
        imgView.fillSuperview()
        imgView.contentMode = .scaleAspectFit
    }
    
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}
