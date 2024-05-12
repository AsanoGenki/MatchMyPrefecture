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
    var name: String = "富山県"
    var capital: String = "富山市"
    var citizen_day: MonthDay? = MonthDay(month: 5, day: 9)
    var has_coast_line: Bool = true
    var logo_url: URL = URL(string: "https://japan-map.com/wp-content/uploads/toyama.png")!
    var brief: String = "富山県（とやまけん）は、日本の中部地方に位置する県。県庁所在地は富山市。\n中部地方の日本海側、新潟県を含めた場合の北陸地方のほぼ中央にある。\n※出典: フリー百科事典『ウィキペディア（Wikipedia）』"
}

