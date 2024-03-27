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
    var tokenManager                : TokenManager
    
    var products                    : [ProductResponse]
    
    init(navigationController       : UINavigationController,
         dataProvider               : DataProvider,
         tokenManager               : TokenManager,
         products                   : [ProductResponse]) {
        self.navigationController   = navigationController
        self.dataProvider           = dataProvider
        self.tokenManager           = tokenManager
        self.products               = products
    }
    
    func start() {
        print("DetailsCoordinator Start")
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
    
    deinit {
        print("DetailsCoordinator Deinit")
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
        if let appC = parentCoordinator as? AccountsCoordinator {
            navigationController.viewControllers.removeLast()
            parentCoordinator?.childDidFinish(self)
        }
    }
    
    func goToDetailsScreen(){
        let detailsViewController       = DetailsViewController()
        let detailsViewModel            = DetailsViewModel(nav: self,
                                                           dataProvider     : dataProvider,
                                                           view             : detailsViewController,
                                                           tokenManager     : tokenManager,
                                                           products         : products)
        
        detailsViewController.viewModel = detailsViewModel
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
