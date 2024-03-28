//
//  AuthTextField.swift
//  MoneyBox
//
//  Created by Mark Golubev on 28/03/2024.
//

import UIKit

final class AuthTextField: UITextField {
    
    // MARK: - Private Properties
    private let padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    // MARK: - Initializers
    init(isSecure: Bool) {
        super.init(frame: .zero)
        setupTextField(isSecure: isSecure)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    // MARK: - Private Methods
    private func setupTextField(isSecure: Bool) {
        textColor = K.Design.secondaryTextColor
        isSecureTextEntry = isSecure
        
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(resource: .accent).cgColor
        backgroundColor = .clear
        
        let buttonAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            if isSecure {
                self.isSecureTextEntry = !self.isSecureTextEntry
            } else {
                text = nil
            }
        }
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: isSecure ? "eye.slash.fill" : "x.circle.fill"), for: .normal)
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .trailing
        configuration.buttonSize = .small
        configuration.baseForegroundColor = (isSecure ? UIColor(resource: .accent) : .lightGray)
        button.configuration = configuration
        button.backgroundColor = .clear
        button.addAction(buttonAction, for: .touchDown)
        
        rightView = button
        rightViewMode = isSecureTextEntry ? .always : .whileEditing
        tintColor = UIColor(resource: .accent)
    }
}
