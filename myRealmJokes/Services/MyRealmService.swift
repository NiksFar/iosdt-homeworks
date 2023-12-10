//
//  MyRealmService.swift
//  myRealmJokes
//
//  Created by Никита on 09.12.2023.
//

import Foundation
import RealmSwift

class RealmJoke: Object {
    @Persisted var joke: String
    @Persisted var category = "No Category"
    @Persisted var loadDate: Double
}

class MyRealmService {
    
    let realm = try! Realm()
    let realmJoke = RealmJoke()
    
    func addJoke(joke: RealmJoke) {
        do {
            try realm.write {
                realm.add(joke)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getJokes(category: String?) -> Results<RealmJoke> {
        let allJokes = realm.objects(RealmJoke.self).sorted(byKeyPath: "loadDate")
        if let category = category {
            let filtered = allJokes.filter("category == %@", category)
            return filtered
        } else {
            return allJokes
        }
    }
    
}
