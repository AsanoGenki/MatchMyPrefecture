//
//  SettingView.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var bgmPlayerManager: BGMPlayerManager
    @AppStorage("BGM") var isPlayingBGM: Bool = true
    @AppStorage("soundEffect") var isPlayingSE = true
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Toggle("BGM", isOn: $isPlayingBGM)
                    .padding(.top, 30)
                    .onChange(of: isPlayingBGM) { play in
                        if play {
                            bgmPlayerManager.playBGM()
                        } else {
                            bgmPlayerManager.stopBGM()
                        }
                    }
                Toggle("効果音", isOn: $isPlayingSE)
                Spacer()
            }
            .font(.system(size: 20))
            .fontWeight(.semibold)
            .padding(.horizontal, 40)
            .navigationBarTitle("", displayMode: .inline)
            
            .navigationBarItems(trailing: Button(action: {
                dismiss()
            }, label: {
                Text("OK")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
            })
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("設定")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                }
            }
            
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
