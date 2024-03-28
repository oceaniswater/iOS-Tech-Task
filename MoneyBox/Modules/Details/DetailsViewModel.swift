//
//  DetailsViewModel.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import Foundation
import Networking

protocol DetailsNavigation : AnyObject {
    func goToDetailsScreen()
    func goToAccountsScreen()
    func goToRootScreen()

}

protocol DetailsViewModelCollectionProtocol: AnyObject {
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    
    var selectedProduct: ProductResponse? { get set }
}

protocol DetailsViewModelProtocol: DetailsViewModelCollectionProtocol {
    var navigation              : DetailsNavigation? { get set }
    var dataProvider            : DataProvider { get set }
    var view                    : DetailsViewControllerDelegate? { get set }
    var tokenManager            : TokenManager { get set }
    var products                : [ProductResponse] { get set }
    var selectedProduct         : ProductResponse? { get set }
    var account                 : Account { get set }
    
    func addMoney()
    func getTitle() -> String
}

class DetailsViewModel: DetailsViewModelProtocol {
    weak var navigation         : DetailsNavigation?
    var dataProvider            : DataProvider
    weak var view               : DetailsViewControllerDelegate?
    var tokenManager            : TokenManager
    
    var products                : [ProductResponse]
    var selectedProduct         : ProductResponse?
    var account                 : Account
    
    init(nav                    : DetailsNavigation,
         dataProvider           : DataProvider,
         view                   : DetailsViewControllerDelegate,
         tokenManager           : TokenManager,
         products               : [ProductResponse],
         account                : Account) {
        
        self.navigation         = nav
        self.dataProvider       = dataProvider
        self.view               = view
        self.tokenManager       = tokenManager
        self.products           = products
        self.account            = account
        
        setupSelectedProduct()
    }
    
    func addMoney() {
        guard let productId = selectedProduct?.id else { return }
        let request = OneOffPaymentRequest(amount: 10, investorProductID: productId)
        dataProvider.addMoney(request: request) { [weak self] result in
            switch result {
            case .success(let success):
                self?.view?.didAddMoneySucces()
                guard let accountId = self?.selectedProduct?.wrapperID else { return }
                self?.getFilteredData(accountId: accountId)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func getFilteredData(accountId: String) {
        dataProvider.fetchProducts { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.products = success.productResponses?.filter { $0.wrapperID == accountId} ?? []
                    self.view?.didUpdateProducts()
                case .failure(let failure):
                    print(failure.localizedDescription)
                    self.tokenManager.deleteToken()
                    UserDefaultsManager.shared.deleteUser()
                    self.goToRoot()
                }
            }
        }
    }
    
    func getTitle() -> String {
        return account.name ?? "Your products"
    }
    
    private func setupSelectedProduct() {
        if products.count == 1 {
            selectedProduct = products.first
            view?.hideSelectProductLabel()
        }
    }
    
    func goToRoot() {
        navigation?.goToRootScreen()
    }
    
    
    deinit {
        print("Deinit details view model")
    }
}

extension DetailsViewModel {
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRows(in section: Int) -> Int {
        self.products.count
    }
}
