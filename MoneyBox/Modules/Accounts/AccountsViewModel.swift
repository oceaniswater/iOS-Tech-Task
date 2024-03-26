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

protocol AccountsViewModelTableProtocol:  AnyObject {
    var products: [ProductResponse] { get set}
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
}

protocol AccountsViewModelProtocol: AccountsViewModelTableProtocol {
    var navigation              : AccountsNavigation! { get set }
    var dataProvider            : DataProvider! { get set }
    var tokenManager            : TokenManager! { get set }
    
    func getUser() -> User?
    func getAccounts()
    func refresh()
    
    func goToDetails()
    func goToRoot()
}

class AccountsViewModel: AccountsViewModelProtocol {
    
    weak var navigation         : AccountsNavigation!
    weak var dataDelegate       : AccountsViewControllerDelegate!
    var dataProvider            : DataProvider!
    var tokenManager            : TokenManager!
    
    private var user            : User?
    private var total           : Double = 0.0
    var products                : [ProductResponse] = []
    
    init(nav                    : AccountsNavigation,
         dataProvider           : DataProvider,
         datatDelegate          : AccountsViewControllerDelegate,
         tokenManager           : TokenManager,
         user                   : User?) {
        self.navigation         = nav
        self.dataProvider       = dataProvider
        self.dataDelegate       = datatDelegate
        self.tokenManager       = tokenManager
        
        self.user               = user
        
        getAccounts()
    }
    
    func getUser() -> User? {
        guard let user = user else { return nil}
        return user
    }
    
    func getTotal() -> Double {
        return total
    }
    
    func getAccounts() {
        dataDelegate.startLoading()
        dataProvider.fetchProducts { [weak self] result in
            switch result {
            case .success(let success):
                self?.products = success.productResponses ?? []
                self?.dataDelegate.didReciveData(total: success.totalPlanValue)
            case .failure(let failure):
                print(failure.localizedDescription)
                self?.tokenManager.deleteToken()
                UserDefaultsManager.shared.deleteUser()
                self?.goToRoot()
            }
            self?.dataDelegate.stopLoading()
        }
    }
    
    func goToDetails(){
        navigation.goToDetailsScreen()
    }
    
    func goToRoot() {
        navigation.goToRootScreen()
    }
    
    func refresh() {
        tokenManager.deleteToken()
        getAccounts()
    }
    
    deinit {
        print("Deinit Accounts view Model")
    }
}

extension AccountsViewModel {
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return self.products.count
    }
}
