//
//  Persistent.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import CoreData

class PersistenceController {
    let container: NSPersistentContainer
    private let errorManager = ErrorManager.shared
    init() {
        container = NSPersistentContainer(name: "MatchMyPrefecture")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if (error as NSError?) != nil {
                self.errorManager.readErrorMessage(
                    message: "データの読み込みに失敗しました。",
                    detail: "アプリを再起動して、もう一度お試しください。"
                )
            }
        })
    }
}
