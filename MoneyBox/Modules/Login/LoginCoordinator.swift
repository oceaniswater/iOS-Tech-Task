//
//  LoginCoordinator.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import UIKit
import Networking

class LoginCoordinator : Coordinator {
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
        print("AuthCoordinator Start")
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
    
    deinit {
        print("AuthCoordinator Deinit")
    }
}

extension LoginCoordinator : LoginNavigation {
    func goToLoginPage(){
        // Instantiate LoginViewModel and set the coordinator
        let loginViewModel = LoginViewModel(nav: self,
                                            dataProvider: dataProvider,
                                            sessionManager: sessionManager)
        // Instantiate LoginViewController
        let loginViewController = LoginViewController()

        // Set the ViewModel to ViewController
        loginViewController.viewModel = loginViewModel
        // Push it.
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func goToAccountsScreen(){
        if let appC = parentCoordinator as? AppCoordinator {
            parentCoordinator?.childDidFinish(self)
            
            appC.goToAccounts()
        }
    }
}
