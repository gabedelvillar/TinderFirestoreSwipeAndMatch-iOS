//
//  AgeRangeCell.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar De Santiago on 11/1/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import UIKit

class AgeRangeCell: UITableViewCell {
    
    let minSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    let maxSlider: UISlider = {
           let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
           return slider
       }()
    
    let minLabel: UILabel = {
        let lbl = AgeRangeLabel()
        lbl.text = "Min 88"
        return lbl
    }()
    
    let maxLabel: UILabel = {
        let lbl = AgeRangeLabel()
        lbl.text = "Max 100"
        return lbl
    }()
    
    
    class AgeRangeLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            return .init(width: 80, height: 0)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       let overallStackView = UIStackView(arrangedSubviews: [UIStackView(arrangedSubviews: [minLabel, minSlider]),
                                                      
                                                      UIStackView(arrangedSubviews: [maxLabel, maxSlider])])
        overallStackView.axis = .vertical
        overallStackView.spacing = 16
        addSubview(overallStackView)
        overallStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}