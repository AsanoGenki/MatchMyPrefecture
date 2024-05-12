//
//  PrefectureMatchingController.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import SwiftUI
import CoreData

final class PrefectureMatchingController: ObservableObject {
    @Published var userName = ""
    @Published var birthDay = Date()
    @Published var bloodType = "A型"
    @Published var result: ResultData = ResultData()
    var bloodTypeReplace = "a"
    let calendar = Calendar(identifier: .gregorian)
    let now = Date()
    //占い結果を取得するAPIの処理
    func readFortuneTelling(viewContext: NSManagedObjectContext) async {
        guard let url = URL(string: "https://yumemi-ios-junior-engineer-codecheck.app.swift.cloud/my_fortune") else {
            print("error")
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("v1", forHTTPHeaderField: "API-Version")
        request.httpMethod = "POST"
        let users: [String: Any] = [
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
        // 受け取ったデータの入力(ユーザーネーム、誕生日、血液型等)
        guard let httpBody = try? JSONSerialization.data(withJSONObject: users) else { return }
        request.httpBody = httpBody
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil
            else {
                print("error", error ?? URLError(.badServerResponse))
                return
            }            
            guard (200...299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(ResultData.self, from: data)                
                DispatchQueue.main.async {
                    // 結果データの出力
                    self.result = responseObject
                }
                self.addResultToCoreData(result: responseObject, viewContext: viewContext)
            } catch {
                print(error)
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                } else {
                    print("unable to parse response as string")
                }
            }
        }
        task.resume()
    }
    func addResultToCoreData(result: ResultData, viewContext: NSManagedObjectContext) {
        let newItem = FortuneResult(context: viewContext)
        newItem.userName = userName
        newItem.birthday = birthDay
        newItem.bloodType = bloodType
        newItem.logoURL = result.logo_url.absoluteString
        newItem.prefecture = result.name
        newItem.createDate = Date()
        do {
            try viewContext.save()
        } catch {
            fatalError("セーブに失敗")
        }
    }
}
