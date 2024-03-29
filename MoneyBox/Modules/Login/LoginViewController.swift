//
//  LoginViewController.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 16.01.2022.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func isLoading(_ isActive: Bool)
    func validationError()
    func showError(message: String)
}

class LoginViewController: UIViewController {
    var viewModel: LoginViewModelProtocol!
    
    // MARK: - Properties
    private let logoView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "moneybox"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Email address"
        label.font = .systemFont(ofSize: 12)
        label.textColor = K.Design.secondaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailTextField: AuthTextField = {
        let textField = AuthTextField(isSecure: false)
        textField.tag = 0
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let invalidEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "The email address you entered is not valid."
        label.font = .systemFont(ofSize: 12)
        label.textColor = K.Design.errorHilightColor
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Email address"
        label.font = .systemFont(ofSize: 12)
        label.textColor = K.Design.secondaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let passwordTextField: AuthTextField = {
        let textField = AuthTextField(isSecure: true)
        textField.tag = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(K.Design.primaryTextColor, for: .normal)
        button.backgroundColor = UIColor(resource: .accent)
        button.layer.cornerRadius = 9
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.layer.opacity = 0.5
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let pinLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in with PIN", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(UIColor(resource: .accent), for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pinButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let forgottenPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgotten password?", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.setTitleColor(UIColor(resource: .accent), for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        //        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var emailStack: UIStackView!
    private var passwordStack: UIStackView!
    
    private let activityView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.tintColor = K.Design.secondaryColor
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupUITextFieldDelegate()
    }
    
    deinit {
        print("Login VC deinit")
    }
    
    // MARK: - Methods
    func isEmalilValidationErrorHilighted(_ isHilighted: Bool ) {
        if isHilighted {
            DispatchQueue.main.async { [weak self] in
                self?.emailTitleLabel.textColor = K.Design.errorHilightColor
                self?.emailTextField.layer.borderColor = K.Design.errorHilightColor?.cgColor
                self?.invalidEmailLabel.isHidden = false
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.emailTitleLabel.textColor = K.Design.secondaryTextColor
                self?.emailTextField.layer.borderColor = UIColor(resource: .accent).cgColor
                self?.invalidEmailLabel.isHidden = true
            }
        }
    }
    
    // MARK: - Actions
    @objc func loginButtonTapped() {
        if viewModel.isValidEmail(emailTextField.text) {
            viewModel.login(email: emailTextField.text!, password: passwordTextField.text!)
        } else {
            isEmalilValidationErrorHilighted(true)
        }
    }
    
    @objc func pinButtonTapped() {
        self.showAlert(message: "It is a test message.") {
        }
    }
    
    @objc private func registerButtonTapped() {
        DispatchQueue.main.async { [weak self] in
            self?.emailTextField.text = "test+ios@moneyboxapp.com"
            self?.passwordTextField.text = "P455word12"
        }
        isEmalilValidationErrorHilighted(false)
        changeLoginButtonState(true)
    }
    
    
}

// MARK: - Setup View
private extension LoginViewController {
    func setupView() {
        view.backgroundColor = K.Design.backgroundColor
        
        addSubview()
        setupLayout()
        setupNavigationBar()
        
    }
    
    func setupNavigationBar() {
        let registerButton = UIButton(type: .system)
        registerButton.setImage(UIImage(systemName: "person.fill.badge.plus"), for: .normal)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        var configuration = UIButton.Configuration.plain()
        configuration.buttonSize = .large
        registerButton.configuration = configuration
        
        let backButtonItem = UIBarButtonItem(customView: registerButton)
        
        navigationItem.rightBarButtonItem = backButtonItem
        navigationController?.navigationBar.backgroundColor = .clear
    }
}

// MARK: - Setting
private extension LoginViewController {
    func addSubview() {
        emailStack = UIStackView(arrangedSubviews: [emailTitleLabel, emailTextField, invalidEmailLabel])
        emailStack.axis = .vertical
        emailStack.spacing = 0
        emailStack.alignment = .leading
        emailStack.distribution = .fillProportionally
        emailStack.translatesAutoresizingMaskIntoConstraints = false
        
        passwordStack = UIStackView(arrangedSubviews: [passwordTitleLabel, passwordTextField])
        passwordStack.axis = .vertical
        passwordStack.spacing = 0
        passwordStack.alignment = .leading
        passwordStack.distribution = .fillProportionally
        passwordStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoView)
        view.addSubview(emailStack)
        view.addSubview(passwordStack)
        view.addSubview(loginButton)
        view.addSubview(activityView)
        view.addSubview(pinLoginButton)
        view.addSubview(forgottenPasswordButton)
    }
}

// MARK: - Setup Layout
private extension LoginViewController {
    func setupLayout() {
        NSLayoutConstraint.activate([
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            logoView.heightAnchor.constraint(equalToConstant: 30),
            
            emailStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailStack.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 60),
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            emailTextField.heightAnchor.constraint(equalToConstant: 45),
            
            passwordStack.topAnchor.constraint(equalTo: emailStack.bottomAnchor, constant: 5),
            passwordStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 45),
            
            forgottenPasswordButton.topAnchor.constraint(equalTo: passwordStack.bottomAnchor),
            forgottenPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            forgottenPasswordButton.heightAnchor.constraint(equalToConstant: 40),
            
            pinLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pinLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pinLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            pinLoginButton.heightAnchor.constraint(equalToConstant: 45),
            
            loginButton.bottomAnchor.constraint(equalTo: pinLoginButton.topAnchor, constant: -10),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            loginButton.heightAnchor.constraint(equalToConstant: 45),
            
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

// MARK: - LoginViewControllerDelegate
extension LoginViewController: LoginViewControllerDelegate {
    func showError(message: String) {
        showAlert(message: message)
    }
    
    func changeLoginButtonState(_ isEnabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.loginButton.isEnabled = isEnabled
            self?.loginButton.layer.opacity = isEnabled ? 1 : 0.5
        }
    }
    
    func validationError() {
        DispatchQueue.main.async { [weak self] in
            self?.emailTitleLabel.textColor = K.Design.errorHilightColor
            self?.invalidEmailLabel.isHidden = false
        }
    }
    
    func isLoading(_ isActive: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.activityView.isHidden = isActive
            if isActive {
                self?.activityView.startAnimating()
            } else {
                self?.activityView.stopAnimating()
            }
        }
    }
}
