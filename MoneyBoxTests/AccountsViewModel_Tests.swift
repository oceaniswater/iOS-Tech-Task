//
//  AccountsViewModel_Tests.swift
//  MoneyBoxTests
//
//  Created by Mark Golubev on 31/03/2024.
//

import XCTest
@testable import MoneyBox
@testable import Networking

final class AccountsViewModel_Tests: XCTestCase {
    
    // Mock dependencies
    class MockNavigation: AccountsNavigation {
        func goToDetailsScreen(account: Account) {
            //
        }
        
        func goToRootScreen() {
            //
        }
    }
    
    class MockDataProvider: DataProviderLogic {
        var productsResult: Result<AccountResponse, Error>?

        func fetchProducts(completion: @escaping ((Result<AccountResponse, any Error>) -> Void)) {
            if let result = productsResult {
                completion(result)
            }
        }
        
        func login(request: Networking.LoginRequest, completion: @escaping ((Result<Networking.LoginResponse, any Error>) -> Void)) {
            //
        }
        
        func addMoney(request: Networking.OneOffPaymentRequest, completion: @escaping ((Result<Networking.OneOffPaymentResponse, any Error>) -> Void)) {
            //
        }
    }
    
    class MockView: AccountsViewControllerDelegate {
        var totalsAreRecievedCalled = false
        var accountsAreRecievedCalled = false
        var showErrorCalled = false
        
        func totalsAreRecieved(totalPlan: Double?, totalSaved: Double) {
            totalsAreRecievedCalled = true
        }
        
        func accountsAreRecieved() {
            accountsAreRecievedCalled = true
        }
        
        func isLoading(_ isActive: Bool) {
            //
        }
        
        func showError(message: String, dismissHandler: (() -> Void)?) {
            showErrorCalled = true
        }
    }
    
    class MockTokenManager: TokenManagerProtocol {
        var deleteTokenCalled = false
        
        func saveToken(_ token: String) {
            //
        }
        
        func getToken() -> String? {
            return nil
        }
        
        func deleteToken() {
            deleteTokenCalled = true
        }
    }
    
    var viewModel: AccountsViewModel!
    var mockNavigation: MockNavigation!
    var mockDataProvider: MockDataProvider!
    var mockView: MockView!
    var mockTokenManager: MockTokenManager!
    
    override func setUpWithError() throws {
        // Initialize mock objects and view model
        mockNavigation = MockNavigation()
        mockDataProvider = MockDataProvider()
        mockView = MockView()
        mockTokenManager = MockTokenManager()
        
        viewModel = AccountsViewModel(dataProvider: mockDataProvider, tokenManager: mockTokenManager, user: nil)
        viewModel.navigation = mockNavigation
        viewModel.view = mockView
    }
    
    override func tearDownWithError() throws {
        // Clean up
        mockNavigation = nil
        mockDataProvider = nil
        mockView = nil
        mockTokenManager = nil
        viewModel.navigation = nil
        viewModel.view = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_AccountsViewModel_getUser_success() throws {
        let mockFirstName = "Mark"
        let mockLastName = "Golubev"
        let user = User(firstName: mockFirstName, lastName: mockLastName)
        let viewModel = AccountsViewModel(dataProvider: mockDataProvider, tokenManager: mockTokenManager, user: user)
        
        let name = viewModel.getUser()
        
        XCTAssertEqual(mockFirstName, name)
    }
    
    func test_AccountsViewModel_getUser_failure() throws {
        let expectedName = "Moneyboxer"
        let user: User? = nil
        let viewModel = AccountsViewModel(dataProvider: mockDataProvider, tokenManager: mockTokenManager, user: user)
        
        let name = viewModel.getUser()
        
        XCTAssertEqual(expectedName, name)
    }
    
    func test_AccountsViewModel_getData_Success() throws {
        StubData.read(file: "Accounts") { [weak self] (result: Result<AccountResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.mockDataProvider.productsResult = .success(response)
            case .failure(let error):
                XCTFail("Error reading stub data: \(error.localizedDescription)")
            }
        }

        viewModel.getData()
        
        XCTAssertGreaterThan(viewModel.products.count, 0)
        XCTAssertGreaterThan(viewModel.accounts.count, 0)
    }
    
    func test_AccountsViewModel_calculateTotalMoneyByAccount_success() throws {
        var accountsTotals: [(account: Account, totalMoney: Double)] = []
        
        StubData.read(file: "Accounts") { [weak self] (result: Result<AccountResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.mockDataProvider.productsResult = .success(response)
                guard let accounts = response.accounts else { break }
                for account in accounts {
                    var money = 0.0
                    guard let products = response.productResponses else { break }
                    for product in products {
                        if account.wrapper?.id == product.wrapperID {
                            money += product.moneybox ?? 0.0
                        }
                    }
                    accountsTotals.append((account: account, totalMoney: money))
                }
            case .failure(let error):
                XCTFail("Error reading stub data: \(error.localizedDescription)")
            }
        }

        viewModel.getData()
        
        let expectedTotalOne = accountsTotals[0].totalMoney
        let expectedTotalTwo = accountsTotals[1].totalMoney
        
        XCTAssertEqual(expectedTotalOne, viewModel.accounts[0].totalMoney)
        XCTAssertEqual(expectedTotalTwo, viewModel.accounts[1].totalMoney)
        
        XCTAssertTrue(mockView.accountsAreRecievedCalled)
        XCTAssertTrue(mockView.totalsAreRecievedCalled)
        
    }
    
    func test_AccountsViewModel_getData_Failure() throws {
        // Stub error
        let error = NSError(domain: "Test error", code: 500, userInfo: nil)
        
        mockDataProvider.productsResult = .failure(error)
        
        viewModel.getData()
        
        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertTrue(mockTokenManager.deleteTokenCalled)
    }
    
    func test_AccountsViewModel_numberOfSections_one() throws {
        let number = viewModel.numberOfSections()
        XCTAssertEqual(number, 1)
    }
    
    func test_AccountsViewModel_numberOfRows_accountsCount() throws {
        var expectedNumber: Int!
        
        StubData.read(file: "Accounts") { [weak self] (result: Result<AccountResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.mockDataProvider.productsResult = .success(response)
            case .failure(let error):
                XCTFail("Error reading stub data: \(error.localizedDescription)")
            }
        }
        viewModel.getData()
        
        expectedNumber = viewModel.accounts.count
        
        let actualNumber = viewModel.numberOfRows(in: 1)
        
        XCTAssertEqual(expectedNumber, actualNumber)
    }
    
    func test_AccountsViewModel_numberOfRows_zero() throws {
        let expectedNumber = 0
        
        let actualNumber = viewModel.numberOfRows(in: 1)
        
        XCTAssertEqual(expectedNumber, actualNumber)
    }
}
