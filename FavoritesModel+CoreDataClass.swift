//
//  FavoritesModel+CoreDataClass.swift
//  Navigation
//
//  Created by Никита on 18.01.2024.
//
//

import Foundation
import CoreData

@objc(FavoritesModel)
public class FavoritesModel: NSManagedObject {
    
// Вспомогательный инициализатор
    convenience init() {
        self.init(entity: CoreDataService.shared.entityForName(entityName: .entityName), insertInto: CoreDataService.shared.context)
    }
    
}
