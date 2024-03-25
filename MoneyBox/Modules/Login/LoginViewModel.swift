//
//  LoginViewModel.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import Foundation

protocol LoginNavigation : AnyObject{
    func goToAccountsScreen()
}

protocol LoginViewModelProtocol {
    var navigation : LoginNavigation! { get set }
    func goToAccounts()
}

class LoginViewModel {
    
    weak var navigation : LoginNavigation!
    
    init(nav : LoginNavigation) {
        self.navigation = nav
    }
    
    func goToAccounts(){
        navigation.goToAccountsScreen()
    }
    
    deinit {
        print("Deinit login")
    }
}
