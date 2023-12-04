//
//  SetupViewController.swift
//  BundleSandboxFileManager
//
//  Created by Никита on 02.12.2023.
//

import Foundation
import UIKit

class SetupViewController: UIViewController {
    
    @IBOutlet weak var buttonm: UIButton!
    
    @IBOutlet weak var sortLabel: UILabel!
    
    @IBOutlet weak var sortSwitch: UISwitch!
    
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var sizeSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemYellow
        setupView()
        DispatchQueue.main.async {
           self.loadPasswordScreen()
        }
    }
    
    func loadPasswordScreen() {
        let vc = LoginViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
    
    @IBAction func sortSwitchAction(_ sender: UISwitch) {
        saveData()
    }
    
    @IBAction func sizeSwitchAction(_ sender: UISwitch) {
        saveData()
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        KeyChainService().updateData()
        loadPasswordScreen()
        
    }
    
    private func saveData() {
        UDService.saveKeyStatus(status: sortSwitch.isOn, key: Keys.sortKey.rawValue)
        UDService.saveKeyStatus(status: true, key: Keys.setupData.rawValue)
        UDService.saveKeyStatus(status: sizeSwitch.isOn, key: Keys.sizeKey.rawValue)
    }
    
    private func setupView() {
        if UDService.getKeyStatus(key: Keys.setupData.rawValue) {
            sortSwitch.isOn = UDService.getKeyStatus(key: Keys.sortKey.rawValue)
            sizeSwitch.isOn = UDService.getKeyStatus(key: Keys.sizeKey.rawValue)
        } else {
            sortSwitch.isOn = true
            sizeSwitch.isOn = true
            saveData()
        }
    }
    
}
