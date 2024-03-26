//
//  LoginViewController.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 16.01.2022.
//

import UIKit

class LoginViewController: UIViewController {
    

    
    var viewModel: LoginViewModelProtocol!
    
    // MARK: - Properties
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "person.fill.badge.plus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let logoView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "moneybox"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Email address"
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "test+ios@moneyboxapp.com"
        return textField
    }()
    
    private let passwordTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Email address"
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "P455word12"
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(resource: .accent)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    deinit {
        print("Login VC deinit")
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        view.addSubview(registerButton)
        view.addSubview(logoView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            registerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -40),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            registerButton.heightAnchor.constraint(equalToConstant: 40),
            
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            logoView.heightAnchor.constraint(equalToConstant: 30),
            
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 60),
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Actions
    @objc private func loginButtonTapped() {
        // Handle login button tapped
        viewModel.login(email: emailTextField.text!, password: passwordTextField.text!)
    }
}
