//
//  AccountsViewController.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import UIKit

protocol AccountsViewControllerDelegate: AnyObject {
    func didReciveData(total: Double?)
    func startLoading()
    func stopLoading()
}

class AccountsViewController: UIViewController {
    
    deinit {
        print("Accounts View Controller deinit")
    }
    
    var viewModel: AccountsViewModelProtocol!
    
    // MARK: - Properties
    
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Total Amount: $0.00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let loginButton: UIButton = {
        let button                                       = UIButton(type: .system)
        button.setTitle("Refresh (test expired/wrong token)", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor                           = UIColor(resource: .accent)
        button.layer.cornerRadius                        = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let activityView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.tintColor = K.Design.secondaryColor
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    @objc private func loginButtonTapped() {
        // Handle login button tapped
        viewModel.refresh()
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = K.Design.backgroundColor
        setupViews()
        setupConstraints()
        setupTableView()
        
        DispatchQueue.main.async { [weak self] in
            let name = self?.viewModel.getUser()?.firstName ?? "Moneyboxer"
            self?.greetingLabel.text = "Hello \(name)!"
        }
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.addSubview(greetingLabel)
        view.addSubview(totalAmountLabel)
        view.addSubview(tableView)
        view.addSubview(loginButton)
        view.addSubview(activityView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            greetingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            totalAmountLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 10),
            totalAmountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalAmountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

extension AccountsViewController: AccountsViewControllerDelegate {
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
    
    func didReciveData(total: Double?) {
        // Set dummy data for testing
        DispatchQueue.main.async { [weak self] in
            self?.totalAmountLabel.text = "Total Amount: $\(total ?? 0.0)"
        }
        
        reloadTableView()
    }
    
    
}


