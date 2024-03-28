//
//  LoginViewController+UITextFieldDelegate.swift
//  MoneyBox
//
//  Created by Mark Golubev on 28/03/2024.
//

import UIKit

extension LoginViewController: UITextFieldDelegate {
    
    func setupUITextFieldDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .done
        
        setupGestureEndEditing()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            passwordTextField.becomeFirstResponder()
        case 1:
            loginButtonTapped()
        default:
            break
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            isEmalilValidationErrorHilighted(false)
        }
    }
    
    // Add gesture recognizer for dismissing the keyboard and resign first responder status
    func setupGestureEndEditing() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
}
