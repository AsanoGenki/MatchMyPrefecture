//
//  ResultData.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import SwiftUI

struct ResultData: Codable {
    struct MonthDay: Codable {
        var month: Int
        var day: Int
    }
    var name: String = "◯◯県"
    var capital: String = "◯◯市"
    var citizenDay: MonthDay? = MonthDay(month: 0, day: 0)
    var hasCoastLine: Bool = true
    var logoUrl: URL = URL(string: "https://japan-map.com/wp-content/uploads/toyama.png")!
    var brief: String = "検索中..."
}
