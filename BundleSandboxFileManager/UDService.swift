//
//  UDService.swift
//  BundleSandboxFileManager
//
//  Created by Никита on 03.12.2023.
//

import Foundation

class UDService {
    
    static func getKeyStatus(key: String) -> Bool {
        let status = UserDefaults.standard.bool(forKey: key)
        print("status loaded", status)
        return status
    }
    
    static func saveKeyStatus(status: Bool, key: String) {
        UserDefaults.standard.set(status, forKey: key)
        print("status saved", status)
    }
    
}
