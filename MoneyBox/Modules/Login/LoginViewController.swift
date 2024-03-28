//
//  LoginViewController.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 16.01.2022.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func startLoading()
    func stopLoading()
}

class LoginViewController: UIViewController {
    var viewModel: LoginViewModelProtocol!
    
    // MARK: - Properties
//    private let registerButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "person.fill.badge.plus"), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
//        return button
//    }()
    
    private let logoView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "moneybox"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Email address"
        label.font = .systemFont(ofSize: 14)
        label.textColor = K.Design.secondaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: AuthTextField = {
        let textField = AuthTextField(isSecure: false)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Email address"
        label.font = .systemFont(ofSize: 14)
        label.textColor = K.Design.secondaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordTextField: AuthTextField = {
        let textField = AuthTextField(isSecure: true)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(K.Design.primaryTextColor, for: .normal)
        button.backgroundColor = UIColor(resource: .accent)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
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
        //        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
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
        view.backgroundColor = K.Design.backgroundColor
        setupViews()
        setupConstraints()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        // Create a custom back button
        let registerButton = UIButton(type: .system)
        registerButton.setImage(UIImage(systemName: "person.fill.badge.plus"), for: .normal)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        // Add left padding to the button to adjust its position
        var configuration = UIButton.Configuration.plain()
        configuration.buttonSize = .large
        registerButton.configuration = configuration
        
        // Create a UIBarButtonItem with the custom button
        let backButtonItem = UIBarButtonItem(customView: registerButton)
        
        // Assign the custom back button to the navigation item
        navigationItem.rightBarButtonItem = backButtonItem
    }
    
    deinit {
        print("Login VC deinit")
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        emailStack = UIStackView(arrangedSubviews: [emailTitleLabel, emailTextField])
        emailStack.axis = .vertical
        emailStack.spacing = 2
        emailStack.alignment = .leading
        emailStack.distribution = .fillProportionally
        emailStack.translatesAutoresizingMaskIntoConstraints = false
        
        passwordStack = UIStackView(arrangedSubviews: [passwordTitleLabel, passwordTextField])
        passwordStack.axis = .vertical
        passwordStack.spacing = 2
        passwordStack.alignment = .leading
        passwordStack.distribution = .fillProportionally
        passwordStack.translatesAutoresizingMaskIntoConstraints = false
        
//        view.addSubview(registerButton)
        view.addSubview(logoView)
        view.addSubview(emailStack)
        view.addSubview(passwordStack)
        view.addSubview(loginButton)
        view.addSubview(activityView)
        view.addSubview(pinLoginButton)
        view.addSubview(forgottenPasswordButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
//            registerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
//            registerButton.heightAnchor.constraint(equalToConstant: 40),
            
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            logoView.heightAnchor.constraint(equalToConstant: 30),
            
            emailStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailStack.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 60),
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordStack.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            forgottenPasswordButton.topAnchor.constraint(equalTo: passwordStack.bottomAnchor),
            forgottenPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            forgottenPasswordButton.heightAnchor.constraint(equalToConstant: 40),
            
            pinLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pinLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pinLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            pinLoginButton.heightAnchor.constraint(equalToConstant: 40),
            
            loginButton.bottomAnchor.constraint(equalTo: pinLoginButton.topAnchor, constant: -10),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    // MARK: - Actions
    @objc private func loginButtonTapped() {
        // Handle login button tapped
        viewModel.login(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @objc private func registerButtonTapped() {
        DispatchQueue.main.async { [weak self] in
            self?.emailTextField.text = "test+ios@moneyboxapp.com"
            self?.passwordTextField.text = "P455word12"
            print("registerButtonTapped")
        }
    }
}

extension LoginViewController: LoginViewControllerDelegate {
    func startLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityView.isHidden = false
            self?.activityView.startAnimating()
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityView.isHidden = true
            self?.activityView.stopAnimating()
        }
    }
}
