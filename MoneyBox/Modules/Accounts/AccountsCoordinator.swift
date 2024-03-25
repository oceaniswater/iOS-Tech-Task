//
//  AccountsCoordinator.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import Foundation
import UIKit

class AccountsCoordinator : Coordinator {
    
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("AuthCoordinator Start")
        goToAccountsScreen()
    }
    
    func childDidFinish(_ child: any Coordinator) {
        children.removeLast()
    }
    
    deinit {
        print("AuthCoordinator Deinit")
    }
}

extension AccountsCoordinator : AccountsNavigation {
    func goToAccountsScreen(){
        // Instantiate AccountsViewController
        let accountsViewController = AccountsViewController()
        // Instantiate AccountsViewModel and set the coordinator
        let accountsViewModel = AccountsViewModel.init(nav: self)
        // Set the ViewModel to ViewController
        accountsViewController.viewModel = accountsViewModel
        // Push it.
        navigationController.pushViewController(accountsViewController, animated: true)
    }
    
    func goToDetailsScreen(){

    }
}
