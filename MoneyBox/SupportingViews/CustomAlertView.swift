////
////  CustomAlertView.swift
////  MoneyBox
////
////  Created by Mark Golubev on 28/03/2024.
////
//
import UIKit

class CustomAlertView {
    typealias DismissHandler = () -> Void
    
    deinit {
        print("alert deinit")
    }
    
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.6
        static let alertViewAlphaTo: CGFloat = 1
        static let alertPadding: CGFloat = 30
    }
    
    private var dismissHandler: DismissHandler?
    private var customAlert: CustomAlertView?
    private var mytargetView: UIView?
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        return backgroundView
    }()
    
    private let alertView: UIView = {
        let alert = UIView()
        alert.backgroundColor = K.Design.secondaryCellColor
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 12
        alert.alpha = 0
        alert.translatesAutoresizingMaskIntoConstraints = false
        return alert
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = K.Design.secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(K.Design.primaryTextColor, for: .normal)
        button.backgroundColor = K.Design.distructiveButtonColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func showAlert(message: String,
                   buttonTitle: String = "OK",
                   on viewController: UIViewController,
                   dismissHandler: DismissHandler? = nil) {
        guard let targetView = viewController.view else { return }
        mytargetView = targetView
        
        backgroundView.frame = targetView.bounds
        
        
        messageLabel.text = message == "Data error" ? "Something is wrong. Check your internet connection or try later." : message
        dismissButton.setTitle(buttonTitle, for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        setupView()
        
        self.dismissHandler = dismissHandler
        
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = Constants.backgroundAlphaTo
            self.alertView.alpha = Constants.alertViewAlphaTo
        }
        
        customAlert = self
    }
    
    @objc private func dismissButtonTapped() {
        customAlert?.dismissAlert()
        dismissHandler?()
        customAlert = nil
    }
    
    private func dismissAlert() {
        UIView.animate(withDuration: 0.25) {
            self.alertView.alpha = 0
            self.backgroundView.alpha = 0
        }
    }
}

// MARK: - Setup View
private extension CustomAlertView {
    func setupView() {
        addSubview()
        setupLayout()
        
    }
}

// MARK: - Setting
private extension CustomAlertView {
    func addSubview() {
        guard let targetView = mytargetView else { return }
        targetView.addSubview(backgroundView)
        targetView.addSubview(alertView)
        alertView.addSubview(messageLabel)
        alertView.addSubview(dismissButton)
    }
}

// MARK: - Setup Layout
private extension CustomAlertView {
    func setupLayout() {
        guard let targetView = mytargetView else { return }
        
        NSLayoutConstraint.activate([
            // Constraints for alert view
            alertView.centerXAnchor.constraint(equalTo: targetView.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: targetView.centerYAnchor),
            alertView.widthAnchor.constraint(equalToConstant: targetView.frame.size.width - 80),
            
            // Constraints for message label
            messageLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: Constants.alertPadding),
            messageLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: Constants.alertPadding),
            messageLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -Constants.alertPadding),
            
            // Constraints for button
            dismissButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: Constants.alertPadding),
            dismissButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),
            dismissButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
