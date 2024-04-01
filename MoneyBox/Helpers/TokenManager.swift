//
//  TokenManager.swift
//  MoneyBox
//
//  Created by Mark Golubev on 26/03/2024.
//

import Foundation
import Security
import Networking

protocol TokenManagerProtocol {
    func saveToken(_ token: String)
    func getToken() -> String?
    func deleteToken()
}

class TokenManager: TokenManagerProtocol {
    
    var sessionManager: SessionManager
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    // MARK: - Constants
    
    /// Unique service identifier for the app
    private let service = "com.moneybox.app.token"
    
    // MARK: - Public Methods
    
    /// Save token to Keychain
    func saveToken(_ token: String) {
        guard let data = token.data(using: .utf8) else {
            return
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecValueData as String: data
        ]
        
        // Delete any existing token first
        deleteToken()
        
        // Add the new token to Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            return
        }
        sessionManager.setUserToken(token)
    }
    
    /// Retrieve token from Keychain
    func getToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess,
              let tokenData = item as? Data,
              let token = String(data: tokenData, encoding: .utf8) else {
            return nil
        }
        
        sessionManager.setUserToken(token)
        
        return token
    }
    
    /// Delete token from Keychain
    func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            return
        }
        
        sessionManager.removeUserToken()
    }
}
