//
//  InfoViewController.swift
//  Navigation
//
//  Created by Никита on 20.02.2023.
//

import UIKit

class InfoViewController: UIViewController, UIAlertViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    private func setupView() {
        setTitle()
        setBackgroundColor()
        addButton()
    }
    
    private func setTitle() {
        title = "Info"
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = UIColor.white
    }
    
    private func addButton() {
        let showAlertButton = UIButton(type: .system)
        showAlertButton.setTitle("Alert", for: .normal)
        showAlertButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        view.addSubview(showAlertButton)
        addConstraints(to: showAlertButton)
    }
    
    private func addConstraints(to button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func showAlert() {
        let alertController = UIAlertController(title: "Notification", message: "Here is some message", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Choosed Cancel")
        }
        
        let okAction = UIAlertAction(title: "ОК", style: .default) { _ in
            print("Choosed Ok")
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
