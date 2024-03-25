//
//  DetailsViewModel.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import Foundation

protocol DetailsNavigation : AnyObject{

}

protocol DetailsViewModelProtocol {
    var navigation : DetailsNavigation! { get set }
}

class DetailsViewModel: DetailsViewModelProtocol {
    weak var navigation : DetailsNavigation!
    
    init(nav : DetailsNavigation) {
        self.navigation = nav
    }
    
    
    deinit {
        print("Deinit login")
    }
}
