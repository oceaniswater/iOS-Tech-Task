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
    func hideSelectProductLabel(_ isHidden: Bool)
    func changeAddMoneyButtonState(_ isEnabled: Bool)
    func isLoading(_ isActive: Bool)
}

class DetailsViewController: UIViewController {
    
    var viewModel: DetailsViewModelProtocol!
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    // MARK: - Private properties
    private let addMoneyButton: UIButton = {
        let button                                       = UIButton(type: .system)
        button.setTitle("Add money: £10", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor                           = UIColor(resource: .accent)
        button.layer.cornerRadius                        = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addMoneyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    private var backView: UIView = {
        let view = UIView()
        view.backgroundColor = K.Design.primaryCellColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var selectProductLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.text = "You need to choose a product to top your moneybox."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.tintColor = K.Design.secondaryColor
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = K.Design.primaryCellColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Restore default navigation bar color when the view controller disappears
        navigationController?.navigationBar.backgroundColor = nil // Restore default color
    }
    
    deinit {
        print("Details VC deinit")
    }
    
    func setupCustomBackButton() {
        // Create a custom back button
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.tintColor = K.Design.primaryTextColor
        
        // Add left padding to the button to adjust its position
        var configuration = UIButton.Configuration.plain()
        configuration.buttonSize = .large
        backButton.configuration = configuration
        
        // Create a UIBarButtonItem with the custom button
        let backButtonItem = UIBarButtonItem(customView: backButton)
        
        // Assign the custom back button to the navigation item
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    // MARK: - Actions
    @objc private func addMoneyButtonTapped() {
        viewModel.addMoney()
    }
    
    @objc func backButtonTapped() {
        viewModel.navigation?.goToAccountsScreen()
    }
}

// MARK: - Setup View
private extension DetailsViewController {
    func setupView() {
        view.backgroundColor = K.Design.backgroundColor
        navigationController?.navigationBar.backgroundColor = K.Design.primaryCellColor
        title = viewModel.getTitle()
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: K.Design.primaryTextColor as Any]
        }
        
        addSubview()
        setupLayout()
        setupTableView()
        setupCustomBackButton()
    }
}

// MARK: - Setting
private extension DetailsViewController {
    func addSubview() {
        view.addSubview(backView)
        view.addSubview(tableView)
        view.addSubview(addMoneyButton)
        view.addSubview(selectProductLabel)
        view.addSubview(activityView)
    }
}

// MARK: - Setup Layout
private extension DetailsViewController {
    func setupLayout() {
        NSLayoutConstraint.activate([
            
            backView.topAnchor.constraint(equalTo: view.topAnchor),
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backView.heightAnchor.constraint(equalToConstant: 200),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            addMoneyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addMoneyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addMoneyButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            addMoneyButton.heightAnchor.constraint(equalToConstant: 40),
            
            
            selectProductLabel.bottomAnchor.constraint(equalTo: addMoneyButton.topAnchor, constant: -20),
            selectProductLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectProductLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            selectProductLabel.leadingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

extension DetailsViewController: DetailsViewControllerDelegate {
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
    
    func changeAddMoneyButtonState(_ isEnabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.addMoneyButton.isEnabled = isEnabled
            self?.addMoneyButton.layer.opacity = isEnabled ? 1 : 0.5
        }
    }
    
    func hideSelectProductLabel(_ isHidden: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.selectProductLabel.isHidden = isHidden
        }
    }
    
    func didUpdateProducts() {
        reloadTableView()
    }
    
    func didAddMoneySucces() {
        reloadTableView()
    }
}
