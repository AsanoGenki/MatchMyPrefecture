//
//  ErrorManager.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/16/24.
//

import Foundation

final class ErrorManager: ObservableObject {
    static let shared = ErrorManager()
    @Published var errorMessage = ""
    @Published var errorMessageDetail = ""
    @Published var isShowingError = false
    private init() {}
    func readErrorMessage(message: String, detail: String) {
        errorMessage = message
        errorMessageDetail = detail
        isShowingError = true
    }
}
