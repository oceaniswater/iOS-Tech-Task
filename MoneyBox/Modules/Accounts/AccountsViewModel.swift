//
//  AccountsViewModel.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import Foundation
import Networking

protocol AccountsNavigation : AnyObject {
    func goToDetailsScreen(products: [ProductResponse], account: Account)
    func goToRootScreen()
}

protocol AccountsViewModelTableProtocol:  AnyObject {
    var accounts: [Account] { get set }
    var products: [ProductResponse] { get set }
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
}

protocol AccountsViewModelProtocol: AccountsViewModelTableProtocol {
    var navigation              : AccountsNavigation? { get set }
    var view                    : AccountsViewControllerDelegate? { get set }
    var dataProvider            : DataProvider { get set }
    var tokenManager            : TokenManager { get set }
    
    func getUser() -> User?
    func getData()
    func refresh()
    
    func goToDetails(account: Account)
    func goToRoot()
}

class AccountsViewModel: AccountsViewModelProtocol {
    
    weak var navigation         : AccountsNavigation?
    weak var view               : AccountsViewControllerDelegate?
    var dataProvider            : DataProvider
    var tokenManager            : TokenManager
    
    private var user            : User?
    private var total           : Double = 0.0
    var accounts                : [Account] = []
    var products                : [ProductResponse] = []
    
    init(nav                    : AccountsNavigation,
         dataProvider           : DataProvider,
         view                   : AccountsViewControllerDelegate,
         tokenManager           : TokenManager,
         user                   : User?) {
        self.navigation         = nav
        self.dataProvider       = dataProvider
        self.view               = view
        self.tokenManager       = tokenManager
        
        self.user               = user
        
        getData()
    }
    
    func getUser() -> User? {
        guard let user = user else { return nil}
        return user
    }
    
    func getTotal() -> Double {
        return total
    }
    
    func getData() {
        view?.startLoading()
        dataProvider.fetchProducts { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.accounts = success.accounts ?? []
                    self.products = success.productResponses ?? []
                    self.view?.didReciveData(total: success.totalPlanValue)
                case .failure(let failure):
                    print(failure.localizedDescription)
                    self.tokenManager.deleteToken()
                    UserDefaultsManager.shared.deleteUser()
                    self.goToRoot()
                }
            }
            self.view?.stopLoading()
        }
    }
    
    func goToDetails(account: Account){
        let filteredProducts = products.filter { $0.wrapperID == account.wrapper?.id}
        print(filteredProducts.count)
        navigation?.goToDetailsScreen(products: filteredProducts, account: account)
    }
    
    func goToRoot() {
        navigation?.goToRootScreen()
    }
    
    func refresh() {
        tokenManager.saveToken("r2zla51MZLfw8aN8sh+iGJM96RX/T+uEaO7UMi3SKxQ=")
        getData()
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
        return self.accounts.count
    }
}
