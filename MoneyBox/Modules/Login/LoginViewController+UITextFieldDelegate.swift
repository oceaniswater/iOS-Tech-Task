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
    
    // Change logic for return button on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            passwordTextField.becomeFirstResponder()
        case 1:
            passwordTextField.resignFirstResponder()
            loginButtonTapped()
        default:
            break
        }
        
        return true
    }
    
    // Remove error hilight when select textfield again
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            isEmalilValidationErrorHilighted(false)
        }
    }
    
    // Enable the Login button if both email and password fields are not empty
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }

        if !email.isEmpty && !password.isEmpty {
            changeLoginButtonState(true)
        } else {
            changeLoginButtonState(false)
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
