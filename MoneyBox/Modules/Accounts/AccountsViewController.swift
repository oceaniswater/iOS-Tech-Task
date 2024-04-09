//
//  AccountsViewController.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import UIKit

protocol AccountsViewControllerDelegate: AnyObject {
    func totalsAreRecieved(totalPlan: Double?, totalSaved: Double)
    func accountsAreRecieved()
    func isLoading(_ isActive: Bool)
    func showError(message: String, dismissHandler: (() -> Void)?)
}

class AccountsViewController: UIViewController {
    
    var viewModel: AccountsViewModelProtocol!
    
    // MARK: - Properties
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.accessibilityIdentifier = "greetingLabel"
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let totalPlanLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Total Plan Value: £0.00"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.accessibilityIdentifier = "totalPlanLabel"
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let totalSavingsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "You already saved: £0.00"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.accessibilityIdentifier = "totalSavingsLabel"
        label.adjustsFontForContentSizeCategory = true
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
        view.isHidden = true
        
        return view
    }()
    
    let tableView: CustomTableView = {
        let tableView = CustomTableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.accessibilityIdentifier = "accountsTableView"
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .trailing
        configuration.buttonSize = .mini
        button.configuration = configuration
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.setTitleColor(UIColor(resource: .accent), for: .normal)
        button.tintColor  = UIColor(resource: .accent)
        button.contentHorizontalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.accessibilityIdentifier = "exploreMoreAccountsButton"
        button.accessibilityLabel = "Explore more accounts"
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Refresh (test expired/wrong token)", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(resource: .accent)
        button.layer.cornerRadius = 9
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        button.accessibilityIdentifier = "logoutButton"
        button.accessibilityLabel = "Refresh (test expired/wrong token)"
        return button
    }()
    
    private let activityView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.tintColor = UIColor(resource: .accent)
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    private var vStack: UIStackView!
    
    @objc private func logoutButtonTapped() {
        viewModel.refresh()
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getData()
    }
}

// MARK: - Setup View
private extension AccountsViewController {
    func setupView() {
        view.backgroundColor = K.Design.backgroundColor
        
        addSubview()
        setupLayout()
        setupName()
    }
    
    func setupName() {
        DispatchQueue.main.async { [weak self] in
            let name = self?.viewModel.getUser()
            self?.greetingLabel.text = "Hello \(name!)!"
        }
    }
}

// MARK: - Setting
private extension AccountsViewController {
    func addSubview() {
        view.addSubview(greetingLabel)
        view.addSubview(totalPlanLabel)
        view.addSubview(totalSavingsLabel)
        
        vStack = UIStackView(arrangedSubviews: [tableViewFormLabel, tableView])
        vStack.axis = .vertical
        vStack.spacing = 10
        vStack.alignment = .leading
        vStack.distribution = .fillProportionally
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        tableViewForm.addSubview(vStack)
        tableViewForm.addSubview(deviderView)
        view.addSubview(tableViewForm)
        tableViewForm.addSubview(exploreMoreAccountsButton)
        
        view.addSubview(logoutButton)
        view.addSubview(activityView)
    }
}

// MARK: - Setup Layout
private extension AccountsViewController {
    func setupLayout() {
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            greetingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            totalPlanLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 10),
            totalPlanLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalPlanLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            totalSavingsLabel.topAnchor.constraint(equalTo: totalPlanLabel.bottomAnchor, constant: 10),
            totalSavingsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalSavingsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableViewForm.topAnchor.constraint(equalTo: totalSavingsLabel.bottomAnchor, constant: 20),
            tableViewForm.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            tableViewForm.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),

            vStack.topAnchor.constraint(equalTo: tableViewForm.topAnchor, constant: 15),
            vStack.leadingAnchor.constraint(equalTo: tableViewForm.leadingAnchor, constant: 15),
            vStack.trailingAnchor.constraint(equalTo: tableViewForm.trailingAnchor, constant: -15),

            tableView.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),

            deviderView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            deviderView.leadingAnchor.constraint(equalTo: tableViewForm.leadingAnchor),
            deviderView.trailingAnchor.constraint(equalTo: tableViewForm.trailingAnchor),
            deviderView.heightAnchor.constraint(equalToConstant: 1),

            exploreMoreAccountsButton.topAnchor.constraint(equalTo: deviderView.bottomAnchor, constant: 5),
            exploreMoreAccountsButton.leadingAnchor.constraint(equalTo: tableViewForm.leadingAnchor, constant: 5),
            exploreMoreAccountsButton.trailingAnchor.constraint(equalTo: tableViewForm.trailingAnchor, constant: -5),
            exploreMoreAccountsButton.bottomAnchor.constraint(equalTo: tableViewForm.bottomAnchor, constant: -5),
            exploreMoreAccountsButton.heightAnchor.constraint(equalToConstant: 40),
            
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            logoutButton.heightAnchor.constraint(equalToConstant: 45),
            
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

// MARK: - AccountsViewControllerDelegate
extension AccountsViewController: AccountsViewControllerDelegate {
    func showError(message: String, dismissHandler: (() -> Void)?) {
        showAlert(message: message, dismissHandler: dismissHandler)
    }
    
    func accountsAreRecieved() {
        reloadTableView()
        tableViewForm.isHidden = false
    }
    
    func isLoading(_ isActive: Bool) {
        activityView.isHidden = isActive
        if isActive {
            activityView.startAnimating()
        } else {
            activityView.stopAnimating()
        }
    }
    
    func totalsAreRecieved(totalPlan: Double?, totalSaved: Double) {
        totalPlanLabel.text    = "Total Plan Value: £\((totalPlan ?? 0.0).toMoneyFormatString())"
        totalSavingsLabel.text = "You already saved: £\(totalSaved.toMoneyFormatString())"
    }
}
