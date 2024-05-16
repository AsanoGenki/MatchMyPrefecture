//
//  StartView.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import SwiftUI

struct StartView: View {
    @State private var isShowingRecordView = false
    @State private var isShowingSettingView = false
    @State private var isShowingMainFortune = false
    @State private var isShowingErrorAlert = false
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var bgmPlayerManager: BGMPlayerManager
    @EnvironmentObject private var sePlayerManager: SEPlayerManager
    @EnvironmentObject private var errorManager: ErrorManager
    @EnvironmentObject private var dataController: PrefectureMatchingController
    @AppStorage("BGM") private var isPlayingBGM: Bool = true
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
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            isShowingMainFortune = true
                        }
                    } label: {
                        ButtonUIView(text: "はじめる", color: .green, backColor: .yellow)
                    }
                    .padding(.bottom)
                    .navigationDestination(isPresented: $isShowingRecordView, destination: {
                        RecordView()
                    })
                    .sheet(isPresented: $isShowingSettingView) {
                        SettingView()
                            .presentationDetents([ .fraction(0.33)])
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
        .alert(errorManager.errorMessage, isPresented: $isShowingErrorAlert) {
            Button("OK") {
                errorManager.isShowingError = false
            }
        } message: {
            Text(errorManager.errorMessageDetail)
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
        .onAppear {
            if errorManager.isShowingError {
                isShowingErrorAlert = true
            }
        }
        .onChange(of: errorManager.isShowingError) { isError in
            if isError {
                isShowingErrorAlert = true
            }
        }
        .fullScreenCover(
            isPresented: $isShowingMainFortune,
            onDismiss: {
                dataController.readFortune = false
            }) {
                MainFortuneView()
            }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
