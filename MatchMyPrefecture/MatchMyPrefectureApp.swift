//
//  MatchMyPrefectureApp.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import SwiftUI

@main
struct MatchMyPrefectureApp: App {
    @StateObject var bgmPlayerManager = BGMPlayerManager.shared
    @StateObject var sePlayerManager = SEPlayerManager.shared
    let persistenceController = PersistenceController()
    var body: some Scene {
        WindowGroup {
            StartView()
                .environment(
                    \.managedObjectContext,
                     persistenceController.container.viewContext
                )
                .environmentObject(bgmPlayerManager)
                .environmentObject(sePlayerManager)
        }
    }
}
