//
//  ErrorManager.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/16/24.
//

import Foundation

class ErrorManager: ObservableObject {
    static let shared = ErrorManager()
    @Published var errorMessage = ""
    @Published var errorMessageDetail = ""
    @Published var isShowingError = false
}
