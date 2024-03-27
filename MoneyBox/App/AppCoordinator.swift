//
//  AppCoordinator.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import UIKit
import Networking

protocol Coordinator: AnyObject {
    var parentCoordinator           : Coordinator? { get set }
    var children                    : [Coordinator] { get set }
    var navigationController        : UINavigationController { get set }
    var tokenManager                : TokenManager { get set }
    
    func start()
    func childDidFinish(_ child: Coordinator?)
}

class AppCoordinator : Coordinator {
    var parentCoordinator           : Coordinator?
    var children                    : [Coordinator] = []
    var navigationController        : UINavigationController
    var tokenManager                : TokenManager
    
    init(navigationController: UINavigationController, tokenManager: TokenManager) {
        self.navigationController   = navigationController
        self.tokenManager           = tokenManager
    }
    
    func start() {
        print("AppCoordinator Start")
        
        // check token
        if let _ = tokenManager.getToken() {
            goToAccounts()
        } else {
            goToLogin()
        }
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in children.enumerated() {
            if coordinator === child {
                children.remove(at: index)
                break
            }
        }
    }
    
    func goToLogin(){
        let dataProvider              = DataProvider()
        let sessionManager            = SessionManager()
        let tokenManager              = TokenManager(sessionManager: sessionManager)
        let authCoordinator           = LoginCoordinator(navigationController: navigationController,
                                                         dataProvider: dataProvider,
                                                         tokenManager: tokenManager)
        authCoordinator.parentCoordinator = self
        children.append(authCoordinator)
        
        authCoordinator.start()
    }
    
    func goToAccounts(){
        let dataProvider              = DataProvider()
        let sessionManager            = SessionManager()
        let tokenManager              = TokenManager(sessionManager: sessionManager)
        let accountsCoordinator       = AccountsCoordinator(navigationController: navigationController,
                                                                 dataProvider: dataProvider,
                                                                 tokenManager: tokenManager)
        accountsCoordinator.parentCoordinator = self
        children.append(accountsCoordinator)
        
        accountsCoordinator.start()
    }
    
    deinit {
        print("AppCoordinator Deinit")
    }
}
