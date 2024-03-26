//
//  LoginViewModel.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import Foundation
import Networking

protocol LoginNavigation : AnyObject{
    func goToAccountsScreen()
}

protocol LoginViewModelProtocol: AnyObject {
    var navigation      : LoginNavigation! { get set }
    var dataProvider    : DataProvider! { get set }
    var sessionManager  : SessionManager! { get set }
    
    func login(email: String, password: String)
    func goToAccounts()
}

class LoginViewModel: LoginViewModelProtocol {
    
    weak var navigation : LoginNavigation!
    var dataProvider    : DataProvider!
    var sessionManager  : SessionManager!
    
    init(nav : LoginNavigation, dataProvider: DataProvider, sessionManager: SessionManager) {
        self.navigation     = nav
        self.dataProvider   = dataProvider
        self.sessionManager = sessionManager
    }
    
    func login(email: String, password: String) {
        let request = LoginRequest(email: email, password: password)
        dataProvider.login(request: request) { [weak self] result in
            switch result {
            case .success(let success):
                let token = success.session.bearerToken
                self?.sessionManager.setUserToken(token)
                self?.goToAccounts()
            case .failure(let failure):
                self?.sessionManager.removeUserToken()
                print(failure.localizedDescription)
            }
        }
    }
    
    func goToAccounts(){
        navigation.goToAccountsScreen()
    }
    
    deinit {
        print("Deinit login view model")
    }
}
