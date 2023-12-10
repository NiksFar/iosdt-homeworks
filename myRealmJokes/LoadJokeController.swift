//
//  LoadJokeController.swift
//  myRealmJokes
//
//  Created by Никита on 09.12.2023.
//

import Foundation
import UIKit

class LoadJokeController: UIViewController {
    
    //var joke: Jokes?
    let realmService = MyRealmService()
    
    private lazy var loadButton: UIButton = {
            let button = UIButton()
            button.setTitle("Load Joke", for: .normal)
            button.backgroundColor = .systemBlue
            button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
            button.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
            button.layer.cornerRadius = 10
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubview(loadButton)
            NSLayoutConstraint.activate([
                loadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                loadButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    
    private func saveJoke(jokes: Jokes) {
        let realmJoke = RealmJoke()
        if !jokes.categories.isEmpty {
            realmJoke.category = jokes.categories.first!
        }
        realmJoke.joke = jokes.value
        print(jokes.value)
        realmJoke.loadDate = Date().timeIntervalSince1970
        realmService.addJoke(joke: realmJoke)
    }
    
    @objc func tapButton() {
        LoadJokeService.loadJson { [self] result in
            switch result {
            case .success(let data):
                if let joke = LoadJokeService.parse(jsonData: data, model: Jokes.self) {
                    DispatchQueue.main.async {
                        self.saveJoke(jokes: joke)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
}
