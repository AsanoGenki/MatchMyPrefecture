//
//  MainFortuneView.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/14/24.
//

import SwiftUI

struct MainFortuneView: View {
    @EnvironmentObject var dataController: PrefectureMatchingController
    var body: some View {
        if dataController.readFortune {
            ResultView()
        } else {
            InputView()
        }
    }
}

#Preview {
    MainFortuneView()
}
