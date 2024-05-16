//
//  PrefectureMatchingController.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import SwiftUI
import CoreData

final class PrefectureMatchingController: ObservableObject {
    static let shared = PrefectureMatchingController()
    @Published var userName = ""
    @Published var birthDay = Date()
    @Published var bloodType = "A型"
    @Published var bloodTypeReplace = "a"
    @Published var result: ResultData = ResultData()
    @Published var readFortune = false
    private let errorManager = ErrorManager.shared
    private let calendar = Calendar(identifier: .gregorian)
    private let now = Date()
    // 占い結果を取得するAPIの処理
    func readFortuneTelling(viewContext: NSManagedObjectContext) async {
        guard let url = URL(string: "https://yumemi-ios-junior-engineer-codecheck.app.swift.cloud/my_fortune") else {
            handleURLError()
            return
        }
        var request = createURLRequest(url: url)
        let users = createUsersDictionary()
        // 受け取ったデータの入力(ユーザーネーム、誕生日、血液型等)
        guard let httpBody = try? JSONSerialization.data(withJSONObject: users) else {
            self.handleJsonError()
            return
        }
        request.httpBody = httpBody
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                self.handleNetworkError()
                return
            }
            guard let data = data,
                  let response = response as? HTTPURLResponse
            else {
                print("error", error ?? URLError(.badServerResponse))
                self.handleServerError()
                return
            }
            guard (200...299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                DispatchQueue.main.async {
                    self.errorManager.errorMessage = "HTTPエラー"
                    self.errorManager.errorMessageDetail = "サーバーエラーが発生しました。ステータスコード: \(response.statusCode)。"
                    self.errorManager.isShowingError = true
                }
                return
            }
            self.decodeData(data, viewContext: viewContext)
        }
        task.resume()
    }
    // API関連の処理
    private func createURLRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("v1", forHTTPHeaderField: "API-Version")
        request.httpMethod = "POST"
        return request
    }
    private func createUsersDictionary() -> [String: Any] {
        return [
            "name": userName,
            "birthday": [
                "year": Int(calendar.component(.year, from: birthDay)),
                "month": Int(calendar.component(.month, from: birthDay)),
                "day": Int(calendar.component(.day, from: birthDay))
            ],
            "blood_type": bloodTypeReplace,
            "today": [
                "year": Int(calendar.component(.year, from: now)),
                "month": Int(calendar.component(.month, from: now)),
                "day": Int(calendar.component(.day, from: now))
            ]
        ]
    }
    private func decodeData(_ data: Data, viewContext: NSManagedObjectContext) {
        let jsonDecoder = JSONDecoder()
        // キャメルケースをスネークケースに自動変換する
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let responseObject = try jsonDecoder.decode(ResultData.self, from: data)
            DispatchQueue.main.async {
                // 結果データの出力
                self.result = responseObject
            }
            self.addResultToCoreData(result: responseObject, viewContext: viewContext)
        } catch {
            DispatchQueue.main.async {
                self.errorManager.errorMessage = "デコードエラー"
                self.errorManager.errorMessageDetail = "サーバーからのデータの解析に失敗しました。もう一度お試しください。"
                self.errorManager.isShowingError = true
            }
            print(error)
            if let responseString = String(data: data, encoding: .utf8) {
                print("responseString = \(responseString)")
            } else {
                print("解析に失敗したデータを文字列として表示できません。")
            }
        }
    }
    // 結果データをローカルに保存
    private func addResultToCoreData(result: ResultData, viewContext: NSManagedObjectContext) {
        let newItem = FortuneResult(context: viewContext)
        newItem.userName = userName
        newItem.birthday = birthDay
        newItem.bloodType = bloodType
        newItem.logoURL = result.logoUrl.absoluteString
        newItem.prefecture = result.name
        newItem.createDate = Date()
        do {
            try viewContext.save()
        } catch {
            DispatchQueue.main.async {
                self.errorManager.errorMessage = "セーブエラー"
                self.errorManager.errorMessageDetail = "占い結果の保存に失敗しました。もう一度お試しください。"
                self.errorManager.isShowingError = true
            }
        }
    }
    // APIのエラー関連の処理
    private func handleURLError() {
        DispatchQueue.main.async {
            self.errorManager.errorMessage = "URLエラー"
            self.errorManager.errorMessageDetail = "有効なURLが見つかりません。もう一度お試しください。"
            self.errorManager.isShowingError = true
        }
    }
    private func handleJsonError() {
        self.errorManager.errorMessage = "エラー"
        self.errorManager.errorMessageDetail = "JSONのシリアル化に失敗しました。"
        self.errorManager.isShowingError = true
    }
    private func handleNetworkError() {
        DispatchQueue.main.async {
            self.errorManager.errorMessage = "ネットワークエラー"
            self.errorManager.errorMessageDetail = "インターネットに接続してもう一度お試しください。"
            self.errorManager.isShowingError = true
        }
    }
    private func handleServerError() {
        DispatchQueue.main.async {
            self.errorManager.errorMessage = "サーバーエラー"
            self.errorManager.errorMessageDetail = "サーバーからの応答が不正です。もう一度お試しください。"
            self.errorManager.isShowingError = true
        }
    }
}
