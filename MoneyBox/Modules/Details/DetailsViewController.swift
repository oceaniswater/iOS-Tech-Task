//
//  DetailsViewController.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import UIKit

protocol DetailsViewControllerDelegate: AnyObject {
    
}

class DetailsViewController: UIViewController {
    
    var viewModel: DetailsViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = K.Design.backgroundColor
    }
    
    deinit {
        print("Details VC deinit")
    }
}

extension DetailsViewController: DetailsViewControllerDelegate {
    
}
