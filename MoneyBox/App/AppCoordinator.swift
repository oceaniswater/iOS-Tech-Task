//
//  AppCoordinator.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import UIKit

protocol Coordinator : AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController : UINavigationController { get set }
    
    func start()
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
        // The first time this coordinator started, is to launch login page.
       goToLogin()
    }
    
    func goToLogin(){
        // For the first time, the app is going to go to Authentication module
        let authCoordinator = AuthCoordinator.init(navigationController: navigationController)
        authCoordinator.parentCoordinator = self
        children.append(authCoordinator)
        
        authCoordinator.start()
    }
    
    deinit {
        print("AppCoordinator Deinit")
    }
    
    
}
