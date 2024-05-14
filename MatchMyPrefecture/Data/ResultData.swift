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
    var citizen_day: MonthDay? = MonthDay(month: 0, day: 0)
    var has_coast_line: Bool = true
    var logo_url: URL = URL(string: "https://japan-map.com/wp-content/uploads/toyama.png")!
    var brief: String = "検索中..."
}

