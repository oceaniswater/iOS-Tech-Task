//
//  AccountsCoordinator.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import UIKit
import Networking

class AccountsCoordinator : Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var dataProvider: DataProvider
    
    var sessionManager: SessionManager
    
    init(navigationController : UINavigationController, dataProvider: DataProvider,
         sessionManager: SessionManager) {
        self.navigationController = navigationController
        self.dataProvider = dataProvider
        self.sessionManager = sessionManager
    }
    
    func start() {
        print("AccountsCoordinator Start")
        goToAccountsScreen()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in children.enumerated() {
            if coordinator === child {
                children.remove(at: index)
                break
            }
        }
    }
    
    func goToRoot() {
        children.removeAll()

    }
    
    deinit {
        print("AccountsCoordinator Deinit")
    }
}

extension AccountsCoordinator : AccountsNavigation {
    func goToDetailsScreen() {
        //
    }
    
    func goToAccountsScreen(){
        // Instantiate AccountsViewController
        let accountsViewController = AccountsViewController()
        // Instantiate AccountsViewModel and set the coordinator
        let accountsViewModel = AccountsViewModel.init(nav: self, sessionManager: sessionManager)
        // Set the ViewModel to ViewController
        accountsViewController.viewModel = accountsViewModel
        // Push it.
        navigationController.pushViewController(accountsViewController, animated: true)
    }
    
    func goToRootScreen(){
        if let appC = parentCoordinator as? AppCoordinator {
            parentCoordinator?.childDidFinish(self)
//            parentCoordinator?.navigationController.popToRootViewController(animated: true)
            appC.goToLogin()
        }
    }
}
