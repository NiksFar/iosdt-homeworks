//
//  PostViewController.swift
//  Navigation
//
//  Created by Никита on 17.02.2023.
//

import UIKit
import CoreData

final class PostViewController: UIViewController {
    
    var postTitle = "New Post"
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    var fetchResultController = CoreDataService.shared.fetchResultController(entityName: .entityName, sortKey: .sortName)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchResultController.delegate = self
        title = postTitle
        view.backgroundColor = UIColor.cyan
        addSubViews()
        setupConstraints()
        
        let infoBarButton = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(infoButton))
        navigationItem.rightBarButtonItem = infoBarButton
        getData()
    }
    
    @objc func infoButton() {
        
        let infoViewController = InfoViewController()
        let navigationController = UINavigationController(rootViewController: infoViewController)
        navigationController.modalPresentationStyle = .pageSheet
        present(navigationController, animated: true, completion: nil)
        
    }
    
    
    
    func addSubViews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)])
    }
    
    func getData() {
        do {
            try fetchResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let post = fetchResultController.object(at: indexPath) as! FavoritesModel
        cell.textLabel?.text = post.author
        cell.detailTextLabel?.text = String(post.likes)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let element = fetchResultController.object(at: indexPath) as! FavoritesModel
            CoreDataService.shared.context.delete(element)
            CoreDataService.shared.saveContext()
        }
    }
    
}

extension PostViewController: NSFetchedResultsControllerDelegate {
   
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            
        case .update:
            if let indexPath = indexPath {
//                let person = fetchResultController.object(at: indexPath) as! Person
//                let cell = dataTableView.cellForRow(at: indexPath)
//                cell?.textLabel?.text = person.name
//                cell?.detailTextLabel?.text = "\(person.age)"
            }
        @unknown default:
            fatalError()
        }
    }
}
