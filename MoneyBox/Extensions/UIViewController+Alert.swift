//
//  UIViewController+Alert.swift
//  MoneyBox
//
//  Created by Mark Golubev on 29/03/2024.
//

import UIKit

extension UIViewController {
    func showAlert(message: String,
                   dismissHandler: (() -> Void)? = nil) {
        let alertView = CustomAlertView()
        alertView.showAlert(message: message, on: self, dismissHandler: dismissHandler)
    }
}
