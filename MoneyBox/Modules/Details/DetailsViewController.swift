//
//  DetailsViewController.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import UIKit

protocol DetailsViewControllerDelegate: AnyObject {
    func didAddMoneySucces()
    func didUpdateProducts()
}

class DetailsViewController: UIViewController {
    
    var viewModel: DetailsViewModelProtocol!
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    // MARK: - Private properties
    private let loginButton: UIButton = {
        let button                                       = UIButton(type: .system)
        button.setTitle("Add money: £10", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor                           = UIColor(resource: .accent)
        button.layer.cornerRadius                        = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    var itemW: CGFloat {
        return screenWidth * 0.8
    }
    
    var itemH: CGFloat {
        return itemW * 0.5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupView()
        setupTableView()
    }
    
    deinit {
        print("Details VC deinit")
    }
    
    // MARK: - Actions
    @objc private func loginButtonTapped() {
        // Handle login button tapped
        viewModel.addMoney()
//        viewModel.navigation?.goToAccountsScreen()
    }
}

// MARK: - Setup View
private extension DetailsViewController {
    func setupView() {
        view.backgroundColor = K.Design.backgroundColor
        
        addSubview()
        setupLayout()
        setupTableView()
        
    }
}

// MARK: - Setting
private extension DetailsViewController {
    func addSubview() {
        view.addSubview(tableView)
        view.addSubview(loginButton)
    }
}

// MARK: - Setup Layout
private extension DetailsViewController {
    func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

extension DetailsViewController: DetailsViewControllerDelegate {
    func didUpdateProducts() {
        reloadTableView()
    }
    
    func didAddMoneySucces() {
        reloadTableView()
    }
}
