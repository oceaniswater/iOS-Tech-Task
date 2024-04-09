//
//  CustomTableView.swift
//  MoneyBox
//
//  Created by Mark Golubev on 07/04/2024.
//

import UIKit

class CustomTableView: UITableView {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return contentSize
    }
    
}
