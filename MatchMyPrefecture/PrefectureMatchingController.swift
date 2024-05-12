//
//  PrefectureMatchingController.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import SwiftUI

final class PrefectureMatchingController: ObservableObject {
    @Published var userName = ""
    @Published var birthDay = Date()
    @Published var bloodType = "A型"
}
