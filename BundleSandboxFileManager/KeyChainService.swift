//
//  KeyChainService.swift
//  BundleSandboxFileManager
//
//  Created by Никита on 02.12.2023.
//

import Foundation
import KeychainAccess

protocol KeychainServiceProtocol {
    func saveData(password: String, key: String)
    func loadData(key: String) -> String?
    func updateData()
}

enum Keys: String {
    case keychainKey = "NF.BundleSandboxFileManager"
    case sortKey = "SortKey"
    case sizeKey = "SizeKey"
    case setupData = "SetupData"
}

class KeyChainService: KeychainServiceProtocol {
    
    let keychain = Keychain(service: "Nikita-Farisey.BundleSandboxFileManager")
    
    
    func saveData(password: String, key: String) {
        keychain[key] = password
        print(keychain[key] as Any)
    }
    
    func loadData(key: String) -> String? {
        do {
            let token = try keychain.get(key)
            print("token", token as Any)
            return token
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func updateData() {
        keychain[Keys.keychainKey.rawValue] = nil
    }
    
}
