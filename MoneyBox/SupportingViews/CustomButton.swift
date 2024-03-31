//
//  CustomButton.swift
//  MoneyBox
//
//  Created by Mark Golubev on 31/03/2024.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        // Enable dynamic type adjustment
        titleLabel?.adjustsFontForContentSizeCategory = true
        titleLabel?.textAlignment = .center
        
        // Set minimum height constraint
        let minHeightConstraint = heightAnchor.constraint(greaterThanOrEqualToConstant: 45)
        minHeightConstraint.priority = .required
        minHeightConstraint.isActive = true
        
        // Add leading, trailing, top, and bottom constraints for titleLabel
        if let titleLabel = titleLabel {
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}
