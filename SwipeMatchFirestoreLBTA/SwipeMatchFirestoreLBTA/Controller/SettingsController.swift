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

protocol SettingsControllerDelegate {
    func didSaveSettings()
}

class CustomImagePickerkController: UIImagePickerController {
    var imgBtn: UIButton?
}

class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: SettingsControllerDelegate?
    
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
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        guard let uploadData = selectedImg?.jpegData(compressionQuality: 0.75) else {return}
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.show(in: self.view)
        ref.putData(uploadData, metadata: nil) { (nil, err) in
            
            if let err = err{
                hud.dismiss()
                print("failed to upload image to storage", err)
                return
            }
            
            print("finished uploading image")
            ref.downloadURL { (url, err) in
                hud.dismiss()
                if let err = err{
                    print("failed to retrieve image to storage", err)
                    return
                }
                print("Finished getting download url", url?.absoluteString ?? "")
                
                if imgBtn == self.imgBtn1 {
                    self.user?.imgUrl1 = url?.absoluteString
                } else if imgBtn == self.imgBtn2{
                    self.user?.imgUrl2 = url?.absoluteString
                } else {
                    self.user?.imgUrl3 = url?.absoluteString
                }
            }
            
        }
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
        if let imageUrl = user?.imgUrl1, let url = URL(string: imageUrl){
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (img, _, _, _, _, _) in
                       self.imgBtn1.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
       
        }
        
        if let imageUrl = user?.imgUrl2, let url = URL(string: imageUrl){
                  SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (img, _, _, _, _, _) in
                             self.imgBtn2.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
              }
             
              }
        
        if let imageUrl = user?.imgUrl3, let url = URL(string: imageUrl){
                  SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (img, _, _, _, _, _) in
                             self.imgBtn3.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
              }
             
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
        case 4:
            headerLabel.text = "Bio"
        default:
            headerLabel.text = "Seeking Age Range"
        }
        
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
        return 300
            
        }
        
        
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    @objc fileprivate func handleMinAgeChange(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        
        ageRangeCell.minLabel.text = "Min: \(Int(slider.value))"
        
        self.user?.minSeekingAge = Int(slider.value)
        
        
    }
    
    @objc fileprivate func handleMaxAgeChange(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
               
               let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
               
               ageRangeCell.maxLabel.text = "Max: \(Int(slider.value))"
        
        self.user?.maxSeekingAge = Int(slider.value)
               
    }
    
    static let defaultMinSeekingAge = 18
    static let defaultMaxSeekingAge = 50
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        
        if indexPath.section == 5 {
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChange), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChange), for: .valueChanged)
            
            let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
            let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
            
            ageRangeCell.minLabel.text = "Min: \(minAge)"
            ageRangeCell.maxLabel.text = "Max: \(maxAge)"
            ageRangeCell.minSlider.value = Float(minAge)
            ageRangeCell.minSlider.value = Float(maxAge)
            return ageRangeCell
        }
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            if let age = user?.age {
                cell.textField.text = String(age)
                
            }
        default:
            cell.textField.placeholder = "Enter Bio"
        }
       
        return cell
    }
    
    @objc fileprivate func handleNameChange(textField: UITextField){
        self.user?.name = textField.text
    }
    
    @objc fileprivate func handleProfessionChange(textField: UITextField){
        self.user?.profession = textField.text
      }
    
    @objc fileprivate func handleAgeChange(textField: UITextField){
        self.user?.age = Int(textField.text ?? "")
      }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItems = [
         UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
          UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        ]
    }
    
    @objc fileprivate func handleLogout(){
        try? Auth.auth().signOut()
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleSave(){
        guard let uid = Auth.auth().currentUser?.uid  else {return}
        let docData: [String: Any] = [
            "uid": uid,
            "fullName": user?.name ?? "",
            "imgUrl1": user?.imgUrl1 ?? "",
            "imgUrl2": user?.imgUrl2 ?? "",
            "imgUrl3": user?.imgUrl3 ?? "",
            "age": user?.age ?? -1,
            "profession": user?.profession ?? "",
            "minSeekingAge": user?.minSeekingAge ?? -1,
            "maxSeekingAge" : user?.maxSeekingAge ?? -1
            
        ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving settings"
        hud.show(in: self.view)
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            hud.dismiss()
            if let err = err{
                print("failed to save user settings", err)
                return
            }
            
            print("finished saving user info")
            self.dismiss(animated: true) {
                self.delegate?.didSaveSettings() // I want to refetch my cards inside of homeController
            }
        }
        
        
    }
    
    @objc fileprivate func handleCancel(){
        dismiss(animated: true)
    }

   
}
