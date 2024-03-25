//
//  DetailsCoordinator.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import Foundation
import UIKit

class DetailsCoordinator : Coordinator {
    
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("AuthCoordinator Start")
        goToDetailsScreen()
    }
    
    func childDidFinish(_ child: any Coordinator) {
        children.removeLast()
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
