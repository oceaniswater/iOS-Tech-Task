//
//  LoginViewModel.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

//import Foundation
//import Networking
//
//protocol LoginNavigation : AnyObject {
//    func goToAccountsScreen()
//}
//
//protocol LoginViewModelProtocol: AnyObject {
//    var navigation             : LoginNavigation? { get set }
//    var dataProvider           : DataProviderLogic { get set }
//    var view                   : LoginViewControllerDelegate? { get set }
//    var tokenManager           : TokenManagerProtocol { get set }
//    
//    func login(email: String, password: String)
//    func isValidEmail(_ email: String?) -> Bool
//    func goToAccounts()
//}
//
//class LoginViewModel: LoginViewModelProtocol {
//    
//    weak var navigation        : LoginNavigation?
//    var dataProvider           : DataProviderLogic
//    weak var view              : LoginViewControllerDelegate?
//    var tokenManager           : TokenManagerProtocol
//    
//    init(nav                   : LoginNavigation,
//         dataProvider          : DataProviderLogic,
//         delegate              : LoginViewControllerDelegate,
//         tokenManager          : TokenManagerProtocol) {
//        
//        self.navigation        = nav
//        self.dataProvider      = dataProvider
//        self.view              = delegate
//        self.tokenManager      = tokenManager
//    }
//    
//    func login(email: String, password: String) {
//        view?.isLoading(true)
//        let request = LoginRequest(email: email, password: password)
//        dataProvider.login(request: request) { [weak self] result in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let success):
//                    let token = success.session.bearerToken
//                    self.tokenManager.saveToken(token)
//                    let user = success.user
//                    UserDefaultsManager.shared.saveUser(user)
//                    self.goToAccounts()
//                case .failure(let failure):
//                    self.tokenManager.deleteToken()
//                    UserDefaultsManager.shared.deleteUser()
//                    self.view?.showError(message: failure.localizedDescription)
//                }
//            }
//            self.view?.isLoading(false)
//        }
//    }
//    
//    func isValidEmail(_ email: String?) -> Bool {
//        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
//        
//        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
//        return emailPredicate.evaluate(with: email)
//    }
//    
//    func goToAccounts(){
//        navigation?.goToAccountsScreen()
//    }
//    
//    deinit {
//        print("Deinit login view model")
//    }
//}
import Foundation
import Networking

protocol LoginNavigation: AnyObject {
    func goToAccountsScreen()
}

protocol LoginViewModelProtocol: AnyObject {
    var navigation: LoginNavigation? { get set }
    
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
        // Pass the error message to the view for display
        view?.showError(message: failure.localizedDescription)
    }
    
    deinit {
        print("Logi VM deinit")
    }
}
