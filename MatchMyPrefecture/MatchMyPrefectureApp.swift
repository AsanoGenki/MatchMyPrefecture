//
//  MatchMyPrefectureApp.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import SwiftUI

@main
struct MatchMyPrefectureApp: App {
    let persistenceController = PersistenceController()
    var body: some Scene {
        WindowGroup {
            StartView()
                .environment(
                    \.managedObjectContext,
                     persistenceController.container.viewContext
                )
        }
    }
}
