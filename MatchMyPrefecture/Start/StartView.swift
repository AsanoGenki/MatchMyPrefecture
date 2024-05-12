//
//  StartView.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import SwiftUI

struct StartView: View {
    @State private var isShowingInputView = false
    @State private var isShowingRecordView = false
    @State private var isShowingSettingView = false
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var bgmPlayerManager: BGMPlayerManager
    @EnvironmentObject var sePlayerManager: SEPlayerManager
    @AppStorage("BGM") var isPlayingBGM: Bool = true
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                VStack {
                    VStack {
                        Text("都道府県")
                            .font(.system(size: 64))
                        Text("相性占い")
                            .font(.system(size: 64))
                        Text("〜今日相性が良い都道府県を占おう！〜")
                            .font(.system(size: 18))
                            .padding(.top, 1)
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    Image("nihonchizu")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.8)
                        .padding(.top, 20)
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        sePlayerManager.playClickNormal()
                        isShowingInputView.toggle()
                    } label: {
                        ButtonUIView(text: "はじめる", color: .green, backColor: .yellow)
                    }
                    .padding(.bottom)
                    .navigationDestination(isPresented: $isShowingInputView, destination: {
                        InputView()
                    })
                    .navigationDestination(isPresented: $isShowingRecordView, destination: {
                        RecordView()
                        
                    })
                    .sheet(isPresented: $isShowingSettingView) {
                        SettingView()
                            .presentationDetents([ .fraction(0.4)])
                    }
                    .navigationBarItems(
                        leading: Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            isShowingSettingView.toggle()
                        } label: {
                            Image(systemName: "gearshape")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        },
                        trailing: Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            isShowingRecordView.toggle()
                        } label: {
                            Image(systemName: "timer")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                    )
                }
            }
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                if isPlayingBGM {
                    bgmPlayerManager.playBGM()
                }
            case .inactive:
                bgmPlayerManager.stopBGM()
            case .background:
                bgmPlayerManager.stopBGM()                
            @unknown default: break
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
