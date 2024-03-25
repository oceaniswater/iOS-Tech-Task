//
//  LoginCoordinator.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import Foundation
import UIKit

class AuthCoordinator : Coordinator {
    
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
    
    let storyboard = UIStoryboard.init(name: "Login", bundle: .main)

    deinit {
        print("AuthCoordinator Deinit")
    }
}

extension AuthCoordinator : LoginNavigation {
//    func goToHome() {
//        // Get the app coordinator
//        let appC = parentCoordinator as! AppCoordinator
//        // And go to home!
//        appC.goToHome()
//        // Remember to clean up
//        parentCoordinator?.childDidFinish(self)
//    }
    
    func goToLoginPage(){
        // Instantiate LoginViewController
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        // Instantiate LoginViewModel and set the coordinator
        let loginViewModel = LoginViewModel.init(nav: self)
        // Set the ViewModel to ViewController
        loginViewController.viewModel = loginViewModel as? LoginViewModelProtocol
        // Push it.
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func goToAccountsScreen(){
        
    }
}
