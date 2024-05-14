//
//  ResultView.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import SwiftUI

struct ResultView: View {
    @State var isShowErrorAlert = false
    @EnvironmentObject var sePlayerManager: SEPlayerManager
    @EnvironmentObject var dataController: PrefectureMatchingController
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                List {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("今日あなたと")
                        Text("相性が良い都道府県は...")
                    }
                    .font(.system(size: 28))
                    .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 30)
                        .padding(.bottom, 10)
                        .listRowSeparator(.hidden)
                    VStack(alignment: .center) {
                        Text(dataController.result.name)
                            .font(.system(size: 30))
                            .fontWeight(.semibold)
                        AsyncImage(url: dataController.result.logo_url, scale: 3) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(maxWidth: geometry.size.width * 0.6)
                        
                    }.frame(maxWidth: .infinity)
                        .listRowSeparator(.hidden)
                    Section("基本情報") {
                        Text("県庁所在地: \(dataController.result.capital)")
                        Text("県民の日: ")
                        + Text(dataController.result.citizen_day != nil ? "\(dataController.result.citizen_day!.month)月\(dataController.result.citizen_day!.day)日" : "なし")
                        Text("海岸線: ")
                        + Text(dataController.result.has_coast_line ? "あり" : "なし")
                    }
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    NavigationLink {
                        PrefectureBriefView(prefecture: $dataController.result.name, brief: $dataController.result.brief)
                            .toolbar {
                                ToolbarItem(placement: .principal) {
                                    Text("特徴")
                                        .font(.system(size: 18))
                                        .fontWeight(.semibold)
                                }
                            }
                    } label: {
                        Text("特徴")
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        sePlayerManager.playClickSmall()
                        dismiss()
                        dataController.readFortune = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            // 入力値を初期値に戻す
                            dataController.userName = ""
                            dataController.birthDay = Date()
                            dataController.bloodType = "A型"
                            dataController.result = ResultData()
                        }
                    } label: {
                        ButtonUIView(text: "ホームに戻る", color: .green, backColor: .yellow)
                    }
                    .listRowSeparator(.hidden)
                        .buttonStyle(PlainButtonStyle())
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                    
                }
                .listStyle(PlainListStyle())
            }
            .alert(dataController.errorMessage, isPresented: $isShowErrorAlert) {
                Button("OK") {
                    dataController.readAPIError = false
                    dataController.readFortune = false
                }
            } message: {
                Text(dataController.errorMessageDetail)
            }
            .onAppear {
                if dataController.readAPIError {
                    isShowErrorAlert = true
                }
            }
            .onChange(of: dataController.readAPIError) { isError in
                if isError {
                    isShowErrorAlert = true
                }
            }
        }
    }
}
