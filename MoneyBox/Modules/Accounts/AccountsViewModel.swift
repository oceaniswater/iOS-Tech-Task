//
//  AccountsViewModel.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import Networking

protocol AccountsNavigation : AnyObject{
    func goToDetailsScreen()
    func goToRootScreen()
}

protocol AccountsViewModelProtocol {
    var navigation : AccountsNavigation! { get set }
    var sessionManager: SessionManager! { get set }
    func goToDetails()
    func goToRoot()
}

class AccountsViewModel: AccountsViewModelProtocol {
    
    weak var navigation : AccountsNavigation!
    weak var sessionManager: SessionManager!
    
    init(nav : AccountsNavigation, sessionManager: SessionManager) {
        self.navigation = nav
        self.sessionManager = sessionManager
        
    }
    
    func goToDetails(){
        navigation.goToDetailsScreen()
    }
    
    func goToRoot() {
        navigation.goToRootScreen()
    }
    
    deinit {
        print("Deinit Accounts view Model")
    }
}
