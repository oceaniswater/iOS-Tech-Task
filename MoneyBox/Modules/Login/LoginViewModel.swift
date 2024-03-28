//
//  LoginViewModel.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import Foundation
import Networking

protocol LoginNavigation : AnyObject {
    func goToAccountsScreen()
}

protocol LoginViewModelProtocol: AnyObject {
    var navigation      : LoginNavigation? { get set }
    var dataProvider    : DataProvider { get set }
    var view        : LoginViewControllerDelegate? { get set }
    var tokenManager    : TokenManager { get set }
    
    func login(email: String, password: String)
    func isValidEmail(_ email: String?) -> Bool
    func isTextFieldsNotEmpty(_ email: String?, _ password: String?) -> Bool
    func goToAccounts()
}

class LoginViewModel: LoginViewModelProtocol {
    
    weak var navigation     : LoginNavigation?
    var dataProvider        : DataProvider
    weak var view           : LoginViewControllerDelegate?
    var tokenManager        : TokenManager
    
    init(nav : LoginNavigation,
         dataProvider: DataProvider,
         delegate: LoginViewControllerDelegate,
         tokenManager: TokenManager) {
        
        self.navigation     = nav
        self.dataProvider   = dataProvider
        self.view       = delegate
        self.tokenManager   = tokenManager
    }
    
    func login(email: String, password: String) {
            view?.startLoading()
            let request = LoginRequest(email: email, password: password)
            dataProvider.login(request: request) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let success):
                        let token = success.session.bearerToken
                        self.tokenManager.saveToken(token)
                        let user = success.user
                        UserDefaultsManager.shared.saveUser(user)
                        self.goToAccounts()
                    case .failure(let failure):
                        self.tokenManager.deleteToken()
                        UserDefaultsManager.shared.deleteUser()
                        print(failure.localizedDescription)
                    }
                }
                self.view?.stopLoading()
            }
    }
    
    func isValidEmail(_ email: String?) -> Bool {
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isTextFieldsNotEmpty(_ email: String?, _ password: String?) -> Bool {
        guard let password = password,
              let email = email,
              !password.isEmpty,
              !email.isEmpty else { return false }
        return true
    }
    
    func goToAccounts(){
        navigation?.goToAccountsScreen()
    }
    
    deinit {
        print("Deinit login view model")
    }
}
