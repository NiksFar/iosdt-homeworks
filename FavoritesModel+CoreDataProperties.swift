//
//  FavoritesModel+CoreDataProperties.swift
//  Navigation
//
//  Created by Никита on 18.01.2024.
//
//

import Foundation
import CoreData


extension FavoritesModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritesModel> {
        return NSFetchRequest<FavoritesModel>(entityName: "FavoritesModel")
    }

    @NSManaged public var author: String?
    @NSManaged public var postDescription: String?
    @NSManaged public var image: String?
    @NSManaged public var likes: Int16
    @NSManaged public var views: Int16

}

extension FavoritesModel : Identifiable {

}
