//
//  Checker.swift
//  Navigation
//
//  Created by Никита on 11.07.2023.
//

import Foundation
import FirebaseAuth
import UIKit


protocol LoginViewControllerDelegate {
    func checkRegistration() -> Bool
    func check(login: String, password: String, completionHandler: @escaping (_ result: Bool) -> Void)
    
}

class Checker: LoginViewControllerDelegate {
    static let share = Checker()
    let fireAuth = FirebaseAuth.Auth.auth()
    var userIsLogined = false
    
//    private let login: String = "111"
//    private let password: String = "111"
//    user: qwerty@yandex.ru, password: qwerty123
    
    func checkRegistration() -> Bool {
        if fireAuth.currentUser != nil {
            print("userID: ", fireAuth.currentUser!.uid)
           
            userIsLogined = true
            return true
        } else {
            return false
        }
    }
    
    func logOut() {
        do {
            try fireAuth.signOut()
            userIsLogined = false
            print("Log Out completed, user: qwerty@yandex.ru, password: qwerty123")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func createNewUser(mail: String, password: String, completionHandler: @escaping (_ textError: String?) -> Void) {
        Checker.share.fireAuth.createUser(withEmail: mail, password: password) { result, error in
            guard error == nil else {
                completionHandler(error!.localizedDescription)
                print(error!.localizedDescription)
                return
            }
            completionHandler(nil)
            print("User has been created", result?.user.uid as Any)
        }
    }
        
        

    func check(login: String, password: String, completionHandler: @escaping (_ result: Bool) -> Void) {
        
        fireAuth.signIn(withEmail: login, password: password) { result, error in
            guard error == nil else {
                print(error!.localizedDescription)
                completionHandler(false)
                return
            }
            print("Authorization complete", result?.user.uid as Any)
            completionHandler(true)
        }
    
        
//        if login == self.login, password == self.password {
//            return true
//        } else {
//            return false
//          }
    }
    
}

struct LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String, completionHandler: @escaping (Bool) -> Void) {
        Checker.share.check(login: login, password: password, completionHandler: completionHandler)
    }
    
    func checkRegistration() -> Bool {
        Checker.share.checkRegistration()
    }
    
//    func check(login: String, password: String) -> Bool {
//        Checker.share.check(login: login, password: password)
//    }
    
}

protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}

struct MyLoginFactory: LoginFactory {
    func makeLoginInspector() -> LoginInspector {
        return LoginInspector()
    }
}
