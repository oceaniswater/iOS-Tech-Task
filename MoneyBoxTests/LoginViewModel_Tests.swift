//
//  LoginViewModel_Tests.swift
//  MoneyBoxTests
//
//  Created by Mark Golubev on 31/03/2024.
//

import XCTest

@testable import MoneyBox
@testable import Networking
final class LoginViewModel_Tests: XCTestCase {
    
    // Mock dependencies
    class MockNavigation: LoginNavigation {
        var goToAccountsScreenCalled = false
        func goToAccountsScreen() {
            goToAccountsScreenCalled = true
        }
    }
    
    class MockDataProvider: DataProviderLogic {
        var loginResult: Result<Networking.LoginResponse, Error>?
        
        func login(request: Networking.LoginRequest, completion: @escaping ((Result<Networking.LoginResponse, any Error>) -> Void)) {
            if let result = loginResult {
                completion(result)
            }
        }
        
        func fetchProducts(completion: @escaping ((Result<Networking.AccountResponse, any Error>) -> Void)) {
            //
        }
        
        func addMoney(request: Networking.OneOffPaymentRequest, completion: @escaping ((Result<Networking.OneOffPaymentResponse, any Error>) -> Void)) {
            //
        }
    }
    
    class MockView: LoginViewControllerDelegate {
        var isErrorShown = false
        
        func isLoading(_ isActive: Bool) {
        }
        
        func validationError() {
        }
        
        func showError(message: String) {
            isErrorShown = true
        }
    }
    
    class MockTokenManager: TokenManagerProtocol {
        var savedToken: String?
        
        func getToken() -> String? {
            return savedToken
        }
        
        func saveToken(_ token: String) {
            savedToken = token
        }
        
        func deleteToken() {
            savedToken = nil
        }
    }
    
    var viewModel: LoginViewModel!
    var mockNavigation: MockNavigation!
    var mockDataProvider: MockDataProvider!
    var mockView: MockView!
    var mockTokenManager: TokenManagerProtocol!
    
    override func setUpWithError() throws {
        mockNavigation = MockNavigation()
        mockDataProvider = MockDataProvider()
        mockView = MockView()
        mockTokenManager = MockTokenManager()
        viewModel = LoginViewModel(dataProvider: mockDataProvider,
                                   tokenManager: mockTokenManager)
        viewModel.view = mockView
        viewModel.navigation = mockNavigation
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockNavigation = nil
        mockDataProvider = nil
        mockView = nil
        mockTokenManager = nil
        super.tearDown()
    }
    
    func test_LoginViewModel_isValidEmail_isValid() throws {
        let validEmails = ["example@mail.co.uk", "example@mail.ru", "example@gmail.com"]
        
        for validEmail in validEmails {
            let result = viewModel.isValidEmail(validEmail)
            
            XCTAssertTrue(result, "\(validEmail)")
        }
    }
    
    func test_LoginViewModel_isInvalidEmail_isInvalid() throws {
        let invalidEmails = ["examplegmail.com", "example@gmailcom", "example@gmail.", "dkdkdkdkdkd"]
        
        for invalidEmail in invalidEmails {
            let result = viewModel.isValidEmail(invalidEmail)
            
            XCTAssertFalse(result, "\(invalidEmail)")
        }
    }
    
    func test_LoginViewModel_login_success() throws {
        var mockToken: String!
        
        // Getting stub response
        StubData.read(file: "LoginSucceed") { [weak self] (result: Result<LoginResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.mockDataProvider.loginResult = .success(response)
                mockToken = response.session.bearerToken
            case .failure(let error):
                XCTFail("Error reading stub data: \(error.localizedDescription)")
            }
            
        }
        
        viewModel.login(email: "test@example.com", password: "password")
        
        XCTAssertTrue(mockNavigation.goToAccountsScreenCalled)
        XCTAssertEqual(mockTokenManager.getToken(), mockToken)
    }
    
    func test_LoginViewModel_login_failed() throws {
        let error = NSError(domain: "Test error", code: 500, userInfo: nil)
        
        mockDataProvider.loginResult = .failure(error)
        
        viewModel.login(email: "test@example.com", password: "password")
        
        XCTAssertTrue(mockView.isErrorShown)
    }
}
