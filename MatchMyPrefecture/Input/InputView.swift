//
//  InputView.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import SwiftUI
import Combine
import CoreData

struct InputView: View {
    @EnvironmentObject var dataController: PrefectureMatchingController
    @State private var editting = false
    @State private var isShowingBirthdaySheet = false
    @State private var isShowingBloodTypeSheet = false
    @State var isShowingResultView = false
    @FocusState var focus: Bool
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var sePlayerManager: SEPlayerManager
    // ユーザーネームが記述されたときに"占う"ボタンが使えるようにする
    var buttonEnable: Bool {
        if !dataController.userName.isEmpty {
            return true
        } else {
            return false
        }
    }
    var body: some View {
        GeometryReader { _ in
            VStack(alignment: .leading, spacing: 28) {
                Text("あなたについて教えてください")
                    .font(.system(size: 23))
                    .fontWeight(.medium)
                    .padding(.top, 50)
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        Text("名前")
                        Spacer()
                        Text("\(dataController.userName.count) / 127")
                    }
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    TextField("山田太郎",
                              text: $dataController.userName,
                              onEditingChanged: { begin in
                        if begin {
                            self.editting = true
                        } else {
                            self.editting = false
                        }
                        
                    })
                    .focused(self.$focus)
                    // 文字数を127文字以内に制限する
                    .onReceive(Just(dataController.userName)) { _ in
                        if dataController.userName.count > 127 {
                            dataController.userName = String(dataController.userName.prefix(127))
                        }
                    }
                    .font(.system(size: 18))
                    .padding(.all)
                    .background{
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                editting && !isShowingBirthdaySheet && !isShowingBloodTypeSheet ? Color.green : Color(UIColor.separator),
                                lineWidth: 3
                            )
                    }
                }
                VStack(alignment: .leading, spacing: 18) {
                    Text("誕生日")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                    Text(dateToString(dateString: dataController.birthDay)!)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.all)
                        .background{
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isShowingBirthdaySheet ? Color.green : Color(UIColor.separator),
                                    lineWidth: 3
                                )
                        }
                        .font(.system(size: 20))
                        .contentShape(RoundedRectangle(cornerRadius: 12))
                        .onTapGesture {
                            self.focus = false
                            self.isShowingBirthdaySheet.toggle()
                        }
                }
                VStack(alignment: .leading, spacing: 18) {
                    Text("血液型")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                    Text(dataController.bloodType)
                        .font(.system(size: 18))
                    
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.all)
                        .background{
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isShowingBloodTypeSheet ? Color.green : Color(UIColor.separator),
                                    lineWidth: 3
                                )
                        }
                        .contentShape(RoundedRectangle(cornerRadius: 12))
                        .onTapGesture {
                            self.focus = false
                            self.isShowingBloodTypeSheet.toggle()
                        }
                }
                Button {
                    if dataController.bloodType == "AB型" {
                        dataController.bloodTypeReplace = "ab"
                    } else {
                        dataController.bloodTypeReplace = dataController.bloodType.first!.description.lowercased()
                    }
                    Task {
                        await dataController.readFortuneTelling(viewContext: viewContext)
                    } 
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    sePlayerManager.playClickNormal()
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        isShowingResultView = true
                    }
                } label: {
                    ButtonUIView(text: "占う", color: .green, backColor: .yellow)
                        .saturation(buttonEnable ? 1 : 0)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .disabled(!buttonEnable)
                Spacer()
            }
            .padding(.horizontal)
            .sheet(isPresented: $isShowingBirthdaySheet) {
                birthdaySheet(birthDay: $dataController.birthDay)
                    .presentationDetents([.fraction(0.35)])
            }
            .sheet(isPresented: $isShowingBloodTypeSheet) {
                bloodTypeSheet(bloodType: $dataController.bloodType)
                    .presentationDetents([.fraction(0.35)])
            }
            .fullScreenCover(isPresented: $isShowingResultView) {
                ResultView(
                    prefecture: $dataController.result.name,
                    capital: $dataController.result.capital,
                    citizanDay: $dataController.result.citizen_day,
                    hasCoastLine: $dataController.result.has_coast_line, logoURL: $dataController.result.logo_url, brief: $dataController.result.brief)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    // Date型のデータをString型にする
    func dateToString(dateString: Date) -> String? {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: dateString)
    }
}
struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}
