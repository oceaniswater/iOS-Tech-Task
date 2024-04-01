//
//  LoginViewModel.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import Foundation
import Networking

protocol LoginNavigation: AnyObject {
    func goToAccountsScreen()
}

protocol LoginViewModelProtocol: AnyObject {
    var navigation: LoginNavigation? { get set }
    var view: LoginViewControllerDelegate? { get set }
    
    func login(email: String, password: String)
    func isValidEmail(_ email: String?) -> Bool
}

class LoginViewModel: LoginViewModelProtocol {
    
    weak var navigation: LoginNavigation?
    weak var view: LoginViewControllerDelegate?
    private let dataProvider: DataProviderLogic
    private let tokenManager: TokenManagerProtocol
    
    init(dataProvider: DataProviderLogic, tokenManager: TokenManagerProtocol) {
        self.dataProvider = dataProvider
        self.tokenManager = tokenManager
    }
    
    func login(email: String, password: String) {
        view?.isLoading(true)
        let request = LoginRequest(email: email, password: password)
        dataProvider.login(request: request) { [weak self] result in
            guard let self = self else { return }
                switch result {
                case .success(let success):
                    self.handleLoginSuccess(success)
                case .failure(let failure):
                    self.handleLoginFailure(failure)
                }
            view?.isLoading(false)
        }
    }
    
    func isValidEmail(_ email: String?) -> Bool {
        guard let email = email else { return false }
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func handleLoginSuccess(_ success: LoginResponse) {
        let token = success.session.bearerToken
        tokenManager.saveToken(token)
        let user = success.user
        UserDefaultsManager.shared.saveUser(user)
        navigation?.goToAccountsScreen()
    }
    
    private func handleLoginFailure(_ failure: Error) {
        tokenManager.deleteToken()
        UserDefaultsManager.shared.deleteUser()
        view?.showError(message: failure.localizedDescription)
    }
}
