//
//  DetailsCoordinator.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import UIKit
import Networking

class DetailsCoordinator : Coordinator {
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
        print("AuthCoordinator Deinit")
    }
}

extension DetailsCoordinator : DetailsNavigation {
    func goToDetailsScreen(){
        // Instantiate AccountsViewController
        let detailsViewController = DetailsViewController()
        // Instantiate AccountsViewModel and set the coordinator
        let detailsViewModel = DetailsViewModel.init(nav: self)
        // Set the ViewModel to ViewController
        detailsViewController.viewModel = detailsViewModel
        // Push it.
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
