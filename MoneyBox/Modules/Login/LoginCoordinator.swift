//
//  LoginCoordinator.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import UIKit
import Networking

class LoginCoordinator: Coordinator {
    weak var parentCoordinator      : Coordinator?
    var children                    : [Coordinator] = []
    var navigationController        : UINavigationController
    var dataProvider                : DataProvider
    var tokenManager                : TokenManagerProtocol
    
    init(navigationController       : UINavigationController,
         dataProvider               : DataProvider,
         tokenManager               : TokenManagerProtocol
    ) {
        self.navigationController   = navigationController
        self.dataProvider           = dataProvider
        self.tokenManager           = tokenManager
    }
    
    func start() {
        goToLoginPage()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in children.enumerated() {
            if coordinator === child {
                children.remove(at: index)
                break
            }
        }
    }
}

extension LoginCoordinator: LoginNavigation {
    func goToLoginPage(){
        let loginViewController = LoginViewController()
        let loginViewModel = LoginViewModel(dataProvider: dataProvider,
                                            tokenManager: tokenManager)
        loginViewModel.navigation = self
        loginViewModel.view = loginViewController

        loginViewController.viewModel = loginViewModel
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func goToAccountsScreen(){
        if let appC = parentCoordinator as? AppCoordinator {
            navigationController.viewControllers.removeLast()
            parentCoordinator?.childDidFinish(self)
            appC.goToAccounts()
        }
    }
}
