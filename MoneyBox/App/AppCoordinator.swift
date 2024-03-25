//
//  AppCoordinator.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController : UINavigationController { get set }
    
    func start()
    func childDidFinish(_ child: Coordinator)
}

class AppCoordinator : Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("AppCoordinator Start")
        
        // check token
        if true {
            goToLogin()
        } else {
            goToAccounts()
        }
       
    }
    
    func childDidFinish(_ child: any Coordinator) {
        children.removeLast()
    }
    
    func goToLogin(){
        let authCoordinator = LoginCoordinator.init(navigationController: navigationController)
        authCoordinator.parentCoordinator = self
        children.append(authCoordinator)
        
        authCoordinator.start()
    }
    
    func goToAccounts(){
        let authCoordinator = LoginCoordinator.init(navigationController: navigationController)
        authCoordinator.parentCoordinator = self
        children.append(authCoordinator)
        
        authCoordinator.start()
    }
    
    deinit {
        print("AppCoordinator Deinit")
    }
    
    
}
