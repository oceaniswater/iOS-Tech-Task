//
//  LoginCoordinator.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import Foundation
import UIKit

class LoginCoordinator : Coordinator {
    
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("AuthCoordinator Start")
        goToLoginPage()
    }
    
    func childDidFinish(_ child: any Coordinator) {
        children.removeLast()
    }
    
    deinit {
        print("AuthCoordinator Deinit")
    }
}

extension LoginCoordinator : LoginNavigation {
    func goToLoginPage(){
        // Instantiate LoginViewController
        let loginViewController = LoginViewController()
        // Instantiate LoginViewModel and set the coordinator
        let loginViewModel = LoginViewModel.init(nav: self)
        // Set the ViewModel to ViewController
        loginViewController.viewModel = loginViewModel
        // Push it.
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func goToAccountsScreen(){
        // Get the app coordinator
        let appC = parentCoordinator as! AppCoordinator
        // And go to home!
        appC.goToAccounts()
        // Remember to clean up
        parentCoordinator?.childDidFinish(self)
    }
}
