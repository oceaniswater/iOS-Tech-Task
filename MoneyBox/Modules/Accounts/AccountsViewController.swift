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
    
    private let tableViewFormLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Your accounts"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableViewForm: UIView = {
        let view = UIView()
        view.backgroundColor = K.Design.secondaryCellColor
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor(.black).cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private lazy var deviderView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let exploreMoreAccountsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Explore more accounts", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14) // Set font size for the title
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .trailing
        configuration.buttonSize = .mini
        button.configuration = configuration
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.setTitleColor(UIColor(resource: .accent), for: .normal)
        button.tintColor = UIColor(resource: .accent)
        button.contentHorizontalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    private var vStack: UIStackView!
    
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
        
        vStack = UIStackView(arrangedSubviews: [tableViewFormLabel, tableView])
        vStack.axis = .vertical
        vStack.spacing = 10
        vStack.alignment = .leading
        vStack.translatesAutoresizingMaskIntoConstraints = false
        

        tableViewForm.addSubview(vStack)
        view.addSubview(tableViewForm)
        view.addSubview(deviderView)
        view.addSubview(exploreMoreAccountsButton)
        
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
            
            tableViewForm.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor, constant: 20),
            tableViewForm.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            tableViewForm.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            vStack.topAnchor.constraint(equalTo: tableViewForm.topAnchor, constant: 15),
            vStack.leadingAnchor.constraint(equalTo: tableViewForm.leadingAnchor, constant: 15),
            vStack.trailingAnchor.constraint(equalTo: tableViewForm.trailingAnchor, constant: -15),
            vStack.bottomAnchor.constraint(equalTo: tableViewForm.bottomAnchor, constant: -15),
            
            tableView.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 100),
            
            deviderView.topAnchor.constraint(equalTo: vStack.bottomAnchor),
            deviderView.leadingAnchor.constraint(equalTo: tableViewForm.leadingAnchor),
            deviderView.trailingAnchor.constraint(equalTo: tableViewForm.trailingAnchor),
            deviderView.heightAnchor.constraint(equalToConstant: 1),
            
            exploreMoreAccountsButton.topAnchor.constraint(equalTo: deviderView.bottomAnchor),
            exploreMoreAccountsButton.leadingAnchor.constraint(equalTo: tableViewForm.leadingAnchor, constant: 5),
            exploreMoreAccountsButton.trailingAnchor.constraint(equalTo: tableViewForm.trailingAnchor, constant: -5),
            exploreMoreAccountsButton.bottomAnchor.constraint(equalTo: tableViewForm.bottomAnchor),
            exploreMoreAccountsButton.heightAnchor.constraint(equalToConstant: 50),
            
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


