//
//  AccountsCoordinator.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import UIKit
import Networking

class AccountsCoordinator: Coordinator {
    weak var parentCoordinator      : Coordinator?
    var children                    : [Coordinator] = []
    var navigationController        : UINavigationController
    var dataProvider                : DataProvider
    var tokenManager                : TokenManagerProtocol
    
    init(navigationController       : UINavigationController,
         dataProvider               : DataProvider,
         tokenManager               : TokenManagerProtocol) {
        self.navigationController   = navigationController
        self.dataProvider           = dataProvider
        self.tokenManager           = tokenManager
    }
    
    func start() {
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
}

extension AccountsCoordinator : AccountsNavigation {
    func goToDetailsScreen(account: Account) {
        let dataProvider              = DataProvider()
        let sessionManager            = SessionManager()
        let tokenManager              = TokenManager(sessionManager: sessionManager)
        let detailsCoordinator        = DetailsCoordinator(navigationController     : navigationController,
                                                           dataProvider             : dataProvider,
                                                           tokenManager             : tokenManager,
                                                           account                  : account)
        detailsCoordinator.parentCoordinator = self
        children.append(detailsCoordinator)
        
        detailsCoordinator.start()
    }
    
    func goToAccountsScreen(){
        let user = UserDefaultsManager.shared.getUser()
        let accountsViewController          = AccountsViewController()
        let accountsViewModel               = AccountsViewModel(
                                                                dataProvider: dataProvider,
                                                                tokenManager: tokenManager,
                                                                user: user)
        accountsViewModel.navigation = self
        accountsViewModel.view = accountsViewController
        accountsViewController.viewModel    = accountsViewModel
        
        navigationController.pushViewController(accountsViewController, animated: true)
    }
    
    func goToRootScreen(){
        if let appC = parentCoordinator as? AppCoordinator {
            navigationController.viewControllers.removeLast()
            parentCoordinator?.childDidFinish(self)
            appC.goToLogin()
        }
    }
}
