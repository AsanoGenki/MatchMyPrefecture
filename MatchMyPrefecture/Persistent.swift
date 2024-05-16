//
//  Persistent.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import CoreData

struct PersistenceController {
    let container: NSPersistentContainer
    init() {
        container = NSPersistentContainer(name: "MatchMyPrefecture")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error)")
            }
        })
    }
}
