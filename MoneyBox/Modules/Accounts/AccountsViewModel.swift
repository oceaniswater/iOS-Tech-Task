//
//  AccountsViewModel.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import Foundation

protocol AccountsNavigation : AnyObject{
    func goToDetailsScreen()
}

protocol AccountsViewModelProtocol {
    var navigation : AccountsNavigation! { get set }
    func goToDetails()
}

class AccountsViewModel: AccountsViewModelProtocol {
    
    weak var navigation : AccountsNavigation!
    
    init(nav : AccountsNavigation) {
        self.navigation = nav
    }
    
    func goToDetails(){
        navigation.goToDetailsScreen()
    }
    
    deinit {
        print("Deinit login")
    }
}
