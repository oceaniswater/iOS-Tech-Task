//
//  DetailsCoordinator.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import UIKit
import Networking

class DetailsCoordinator : Coordinator {
    weak var parentCoordinator      : Coordinator?
    var children                    : [Coordinator] = []
    var navigationController        : UINavigationController
    var dataProvider                : DataProvider
    var tokenManager                : TokenManagerProtocol
    
    var account                     : Account
    
    init(navigationController       : UINavigationController,
         dataProvider               : DataProvider,
         tokenManager               : TokenManagerProtocol,
         account                    : Account) {
        
        self.navigationController   = navigationController
        self.dataProvider           = dataProvider
        self.tokenManager           = tokenManager
        self.account                = account
    }
    
    func start() {
        goToDetailsScreen()
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

extension DetailsCoordinator : DetailsNavigation {
    func goToRootScreen() {
        if let appC = parentCoordinator as? AccountsCoordinator {
            navigationController.viewControllers.removeLast()
            parentCoordinator?.childDidFinish(self)
            appC.goToRootScreen()
        }
    }
    
    func goToAccountsScreen() {
        if let _ = parentCoordinator as? AccountsCoordinator {
            navigationController.viewControllers.removeLast()
            parentCoordinator?.childDidFinish(self)
        }
    }
    
    func goToDetailsScreen(){
        let detailsViewController       = DetailsViewController()
        let detailsViewModel            = DetailsViewModel(dataProvider: dataProvider,
                                                           tokenManager: tokenManager,
                                                           account     : account)
        detailsViewModel.navigation = self
        detailsViewModel.view = detailsViewController
        
        detailsViewController.viewModel = detailsViewModel
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
