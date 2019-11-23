//
//  ChatlogController.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar De Santiago on 11/21/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import LBTATools

struct Message {
    let text: String
    let isFromCurrentLoggedUser: Bool
}

class MessageCell: LBTAListCell<Message> {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 20)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
   
    let bubbleContainer = UIView(backgroundColor: #colorLiteral(red: 0.90670681, green: 0.9017671347, blue: 0.9060887694, alpha: 1))
    
    override var item: Message!{
        didSet{
            
            textView.text = item.text
            
            
            if item.isFromCurrentLoggedUser {
                
                // right edge
                anchoredConstraints.trailing?.isActive = true
                anchoredConstraints.leading?.isActive = false
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.07526930422, green: 0.7676367164, blue: 0.9983822703, alpha: 1)
                textView.textColor = .white
            } else{
                anchoredConstraints.trailing?.isActive = false
                anchoredConstraints.leading?.isActive = true
                 bubbleContainer.backgroundColor = #colorLiteral(red: 0.90670681, green: 0.9017671347, blue: 0.9060887694, alpha: 1)
                textView.textColor = .black
            }
        }
    }
    
    var anchoredConstraints: AnchoredConstraints!
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(bubbleContainer)
        
        bubbleContainer.layer.cornerRadius = 12
        
        let anchoredConstraints = bubbleContainer.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
        anchoredConstraints.leading?.constant = 20
        
        anchoredConstraints.trailing?.isActive = false
        
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        bubbleContainer.addSubview(textView)
        textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
    }
}



class ChatLogController: LBTAListController<MessageCell, Message>, UICollectionViewDelegateFlowLayout {
    
    fileprivate lazy var customNavBar = MessagesNavBar(match: match)
    
    fileprivate let navBarHeight: CGFloat = 120
    
    fileprivate let match: Match
    
    init(match: Match){
        self.match = match
        super.init()
    }
    
    // input accessory view
    
    class CustomInputAcessView: UIView {
        
        let textView = UITextView()
         let sendButton = UIButton(title: "SEND", titleColor: .black, font: .boldSystemFont(ofSize: 14), target: nil, action: nil)
        
        let placeholderLabel = UILabel(text: "Enter Message", font: .systemFont(ofSize: 16), textColor: .lightGray)
        
        override var intrinsicContentSize: CGSize {
            return .zero
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            
            backgroundColor = .white
                   setupShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: -8), color: .lightGray)
                   autoresizingMask = .flexibleWidth
                   
                   
                   
                   
                   textView.isScrollEnabled = false
                   
            textView.font = .systemFont(ofSize: 16)
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
                   
                   hstack(textView,
                                  sendButton.withSize(.init(width: 60, height: 60)),
                                  alignment: .center
                   ).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
            
            addSubview(placeholderLabel)
            placeholderLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: sendButton.leadingAnchor, padding: .init(top: 0, left: 18, bottom: 0, right: 0))
            placeholderLabel.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
            
        }
        
        @objc fileprivate func handleTextChange() {
            placeholderLabel.isHidden = textView.text.count != 0
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    lazy var redView: UIView = {
         let redView = CustomInputAcessView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
       
        
        
        return redView
    }()
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView?{
        get{
            return redView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        collectionView.keyboardDismissMode = .interactive
        
        items = [
            .init(text: "A very long sting to show that the code we just implemented that does auto resizieng for cells actually works", isFromCurrentLoggedUser: true),
            .init(text: "Hello Bud", isFromCurrentLoggedUser: true),
            .init(text:  "Hellow from the Tinder course", isFromCurrentLoggedUser: true),
        ]
        
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: navBarHeight))
        
        collectionView.contentInset.top = navBarHeight
        collectionView.scrollIndicatorInsets.top = navBarHeight
        
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        let statusBarCover = UIView(backgroundColor: .white)
        
        view.addSubview(statusBarCover)
        
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        // estimated sizing
        
        let estimatedSizeCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        
        estimatedSizeCell.item = self.items[indexPath.item]
        
        estimatedSizeCell.layoutIfNeeded()
        
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
