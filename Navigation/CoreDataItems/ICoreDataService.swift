//
//  ICoreDataService.swift
//  Navigation
//
//  Created by Никита on 18.01.2024.
//

import CoreData
import Foundation

protocol ICoreDataService {
    
    var context: NSManagedObjectContext { get }
    func entityForName(entityName: String) -> NSEntityDescription
    func fetchResultController(entityName: String, sortKey: String) -> NSFetchedResultsController<NSFetchRequestResult>
    func saveContext()
    
}

final class CoreDataService: ICoreDataService {
    
    static let shared: ICoreDataService = CoreDataService()
    private init() {}
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: .coreDataBaseName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription)
                assertionFailure("Load Persistent Stores error")
            }
        }
        return container
    }()
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
                assertionFailure("Save Error")
            }
        }
    }
    
    func entityForName(entityName: String) -> NSEntityDescription {
            return NSEntityDescription.entity(forEntityName: entityName, in: context)!
        }
    
    func fetchResultController(entityName: String, sortKey: String) -> NSFetchedResultsController<NSFetchRequestResult> {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataService.shared.context, sectionNameKeyPath: nil, cacheName: nil)
            return fetchResultController
        }
    
}

 extension String {
    static let coreDataBaseName = "FavoritesDataModel"
    static let sortName = "likes"
    static let entityName = "FavoritesModel"
}


