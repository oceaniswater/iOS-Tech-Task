//
//  DetailsViewModel.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import Foundation
import Networking

protocol DetailsNavigation : AnyObject{

}

protocol DetailsViewModelProtocol {
    var navigation              : DetailsNavigation? { get set }
    var dataProvider            : DataProvider { get set }
    var view                    : DetailsViewControllerDelegate? { get set }
    var tokenManager            : TokenManager { get set }
    var products                : [ProductResponse] { get set }
}

class DetailsViewModel: DetailsViewModelProtocol {
    weak var navigation         : DetailsNavigation?
    var dataProvider            : DataProvider
    weak var view               : DetailsViewControllerDelegate?
    var tokenManager            : TokenManager
    
    var products                : [ProductResponse]
    
    init(nav                    : DetailsNavigation,
         dataProvider           : DataProvider,
         view                   : DetailsViewControllerDelegate,
         tokenManager           : TokenManager,
         products               : [ProductResponse]) {
        self.navigation         = nav
        self.dataProvider       = dataProvider
        self.view               = view
        self.tokenManager       = tokenManager
        self.products           = products
        
        printcount()
    }
    
    deinit {
        print("Deinit details view model")
    }
    
    func printcount() {
        print(products.count)
    }
}
