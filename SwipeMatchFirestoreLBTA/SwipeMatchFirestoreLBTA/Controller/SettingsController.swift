//
//  SettingsController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar De Santiago on 10/30/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

class CustomImagePickerkController: UIImagePickerController {
    var imgBtn: UIButton?
}

class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    lazy var imgBtn1 = createButton(selector: #selector(handleSelectPhoto))
    lazy var imgBtn2 = createButton(selector: #selector(handleSelectPhoto))
    lazy var imgBtn3 = createButton(selector: #selector(handleSelectPhoto))
    
    
    @objc func handleSelectPhoto(button: UIButton) {
        let imgPicker = CustomImagePickerkController()
        imgPicker.delegate = self
        imgPicker.imgBtn = button
        present(imgPicker, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImg = info[.originalImage] as? UIImage
        
        let imgBtn = (picker as? CustomImagePickerkController)?.imgBtn
        
        imgBtn?.setImage(selectedImg?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true)
    }
    
    func createButton(selector: Selector) -> UIButton{
        let btn = UIButton(type: .system)
        btn.setTitle("Select Photo", for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: selector, for: .touchUpInside)
        btn.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        return btn
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.96, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        
        
        fetchCurrentUser()
    }
    
    var user: User?
    
    fileprivate func fetchCurrentUser(){
        // Fetch some firestore data
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err{
                print(err)
                return
            }
            
            // fetched our user
            guard let dictionary = snapshot?.data() else {return}
            self.user = User(dictionary: dictionary)
            self.loadUserPhotos()
            
            self.tableView.reloadData()
        }
        
    }
    
    
    fileprivate func loadUserPhotos() {
        guard let imageUrl = user?.imgUrl1, let url = URL(string: imageUrl) else {return}
        SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (img, _, _, _, _, _) in
            self.imgBtn1.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
    }
    
    
    lazy var header: UIView = {
        let header = UIView()
        header.backgroundColor = .white
        header.addSubview(imgBtn1)
        let padding: CGFloat = 16
        imgBtn1.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        
        imgBtn1.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [imgBtn2, imgBtn3])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor, leading: imgBtn1.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        
        stackView.spacing = padding
        return header
    }()
    
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy:0))
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return header
        }
        
        
        let headerLabel = HeaderLabel()
        
        switch section {
        case 1:
            headerLabel.text = "Name"
        case 2:
            headerLabel.text = "Profession"
        case 3:
            headerLabel.text = "Age"
        default:
            headerLabel.text = "Bio"
        }
        
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
        return 300
            
        }
        
        
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
        case 3:
            cell.textField.placeholder = "Enter Age"
            if let age = user?.age {
                cell.textField.text = String(age)
            }
        default:
            cell.textField.placeholder = "Enter Bio"
        }
       
        return cell
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItems = [
         UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleCancel)),
          UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel))
        ]
    }
    
    @objc fileprivate func handleCancel(){
        dismiss(animated: true)
    }

   
}
