//
//  AccountsViewController.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import UIKit

class AccountsViewController: UIViewController {
    
    deinit {
        print("Accounts View Controller deinit")
    }
    
    var viewModel: AccountsViewModelProtocol!
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    private func setupViews() {

        view.addSubview(loginButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 100),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Actions
    @objc private func loginButtonTapped() {
        
        viewModel.goToRoot()
    }
}
