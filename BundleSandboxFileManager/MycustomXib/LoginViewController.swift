//
//  LoginViewController.swift
//  BundleSandboxFileManager
//
//  Created by Никита on 02.12.2023.
//

import UIKit


class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let keychain = KeyChainService()
    var currentPassword: String?
    var firstPassword: String = ""
    let bundleKey = Keys.keychainKey.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        setupView()
        checkPassword()
        
    }
    
    func setupView() {
        loginButton.setTitle("Create Password", for: .normal)
        passwordTextField.placeholder = "Password"
        
        passwordTextField.text = nil
        firstPassword = ""
    }

    
    func alert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        // Пароль уже существует
        if currentPassword != nil {
            logIn(text: passwordTextField.text!)
        } else {
            // Создаем пароль
            repeatPassword()
        }
    }
    
    func checkPassword() {
        currentPassword = keychain.loadData(key: bundleKey)
        if currentPassword != nil {
            loginButton.setTitle("Enter Password", for: .normal)
        }
    }
    
    func logIn(text: String) {
        guard let password = currentPassword else { return }
        if text == password {
            self.dismiss(animated: true)
        } else {
            alert(message: "Wrong password")
        }

    }
    
    func repeatPassword() {
        let currentText = passwordTextField.text!
        guard currentText.count > 3 else {
            alert(message: "Password should be at least 4 signs")
            return
        }
        // Первый пароль уже введен
        if firstPassword != "" {
            // Пароли совпадают
            if currentText == firstPassword {
                keychain.saveData(password: currentText, key: bundleKey)
                self.dismiss(animated: true)
            } else {
                // Пароли не совпадают
                alert(message: "Passwords are not equal")
                setupView()
            }
        } else {
            // Создаем первый пароль
            firstPassword = currentText
            loginButton.setTitle("Repeat Password", for: .normal)
            passwordTextField.text = nil
        }
        

    }
    
}
