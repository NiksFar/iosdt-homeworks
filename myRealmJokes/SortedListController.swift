//
//  SortedListController.swift
//  myRealmJokes
//
//  Created by Никита on 09.12.2023.
//

import Foundation
import UIKit
import RealmSwift

class SortedListController: UIViewController {
    
    var jokesTableView = UITableView()
    var jokesArray: Results<RealmJoke>?
    let realmService = MyRealmService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupConstraints()
        jokesTableView.delegate = self
        jokesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        jokesArray = realmService.getJokes(category: nil)
        jokesTableView.reloadData()
    }
    
    private func setupConstraints() {
        jokesTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(jokesTableView)
            NSLayoutConstraint.activate([
                jokesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                jokesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                jokesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                jokesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    
    func dateTItoString(dateTI: Double) -> (String){
        let date = Date(timeIntervalSince1970: dateTI)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateDMY = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "HH:mm"
        let dateHM = dateFormatter.string(from: date)
        print("dateDMY" ,dateDMY, "dateHM", dateHM)
        return(dateHM)
    }
    
}

extension SortedListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jokesArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        guard let array = jokesArray else { return UITableViewCell() }
        let joke = array[indexPath.row]
        cell.textLabel?.text = joke.joke
        cell.detailTextLabel?.text = dateTItoString(dateTI: joke.loadDate)
        return cell
    }
    
    
}
