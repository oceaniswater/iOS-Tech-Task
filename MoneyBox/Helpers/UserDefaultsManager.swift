//
//  UserDefaultsManager.swift
//  MoneyBox
//
//  Created by Mark Golubev on 26/03/2024.
//

import Foundation
import Networking

typealias User = LoginResponse.User

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let userDefaults = UserDefaults.standard
    private let userKey = "CurrentUser"
    
    private init() {}
    
    func saveUser(_ user: User) {
        do {
            let userData = try JSONEncoder().encode(user)
            userDefaults.set(userData, forKey: userKey)
        } catch {
            print("Error encoding user: \(error)")
        }
    }
    
    func getUser() -> User? {
        guard let userData = userDefaults.data(forKey: userKey) else { return nil }
        do {
            let user = try JSONDecoder().decode(User.self, from: userData)
            return user
        } catch {
            print("Error decoding user: \(error)")
            return nil
        }
    }
    
    func deleteUser() {
        userDefaults.removeObject(forKey: userKey)
    }
}
