//
//  CategoryJokeController.swift
//  myRealmJokes
//
//  Created by Никита on 09.12.2023.
//

import Foundation
import UIKit
import RealmSwift

class CategoryJokeController: UIViewController {
    
    var categoryTableView = UITableView()
    var categoryArray: [String] = []
    let realmService = MyRealmService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupConstraints()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoryArray = getCategoryArray()
        categoryTableView.reloadData()
    }
    
    private func setupConstraints() {
        categoryTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryTableView)
        NSLayoutConstraint.activate([
            categoryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            categoryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            categoryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func getCategoryArray() -> [String] {
        let jokesArray = realmService.getJokes(category: nil)
        var array: [String] = []
        for jokes in jokesArray {
            let category = jokes.category
            if !array.contains(category) {
                array.append(category)
            }
        }
        return array
    }
    
    func getJokesArray(category: String) -> [String] {
        let jokesArray = realmService.getJokes(category: category)
        var array: [String] = []
        for jokes in jokesArray {
            let joke = jokes.joke
            if !array.contains(joke) {
                array.append(joke)
            }
        }
        return array
    }
    
}

extension CategoryJokeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoryArray[indexPath.row]
        categoryArray = getJokesArray(category: category)
        tableView.reloadData()
    }
    
    
}
