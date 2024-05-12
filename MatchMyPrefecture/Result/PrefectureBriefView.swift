//
//  PrefectureBriefView.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import SwiftUI

struct PrefectureBriefView: View {
    @Binding var prefecture: String
    @Binding var brief: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(brief)
                .padding(.top, 20)
                .lineSpacing(7)
            Link("ウィキペディアでもっと詳しく読む", destination: wikiURL(prefecture: prefecture))
            Spacer()
        }
        .font(.system(size: 18))
        .fontWeight(.semibold)
        .padding(.horizontal)
    }
    // 日本語をリンクに含めると文字化けしてしまうため、エンコーディングを行う
    func wikiURL(prefecture: String) -> URL {
        let urlString = "https://ja.wikipedia.org/wiki/\(prefecture)"
        let encodeUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return URL(string: encodeUrlString)!
    }
}
