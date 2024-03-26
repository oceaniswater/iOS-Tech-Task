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
    var delegate        : LoginViewControllerDelegate! { get set }
    var tokenManager    : TokenManager! { get set }
    
    func login(email: String, password: String)
    func goToAccounts()
}

class LoginViewModel: LoginViewModelProtocol {
    
    weak var navigation     : LoginNavigation!
    var dataProvider        : DataProvider!
    var delegate            : LoginViewControllerDelegate!
    var tokenManager        : TokenManager!
    
    init(nav : LoginNavigation,
         dataProvider: DataProvider,
         delegate: LoginViewControllerDelegate,
         tokenManager: TokenManager) {
        
        self.navigation     = nav
        self.dataProvider   = dataProvider
        self.delegate       = delegate
        self.tokenManager   = tokenManager
    }
    
    func login(email: String, password: String) {
        delegate.startLoading()
        let request = LoginRequest(email: email, password: password)
        dataProvider.login(request: request) { [weak self] result in
            switch result {
            case .success(let success):
                let token = success.session.bearerToken
                self?.tokenManager.saveToken(token)
                let user = success.user
                UserDefaultsManager.shared.saveUser(user)
                self?.goToAccounts()
            case .failure(let failure):
                self?.tokenManager.deleteToken()
                UserDefaultsManager.shared.deleteUser()
                print(failure.localizedDescription)
            }
            self?.delegate.stopLoading()
        }
    }
    
    func goToAccounts(){
        navigation.goToAccountsScreen()
    }
    
    deinit {
        print("Deinit login view model")
    }
}
