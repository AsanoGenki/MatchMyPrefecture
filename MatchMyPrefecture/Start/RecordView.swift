//
//  RecordView.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import SwiftUI
import CoreData

struct RecordView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\FortuneResult.createDate, order: .reverse)])
    private var resultItems: FetchedResults<FortuneResult>
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    @State private var isShowingNetworkError = false
    @State private var isShowingAllDeleteAlert = false
    @State private var isShowingErrorAlert = false
    @State private var errorMessage = ""
    @State private var errorMessageDetail = ""
    @State private var sortOrder = "新しい順"
    var body: some View {
        List {
            ForEach(resultItems, id: \.self) { item in
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(item.userName!)
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .padding(.bottom, 10)
                        HStack(spacing: 0) {
                            Image(systemName: "birthday.cake")
                            Text(dateToString(dateString: item.birthday!)!)
                                .padding(.trailing, 5)
                            Image(systemName: "drop")
                            Text(item.bloodType!)
                                .padding(.trailing, 5)
                            Image(systemName: "calendar")
                            Text(dateToString(dateString: item.createDate!)!.suffix(5))
                        }
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                    }
                    Spacer()
                    ZStack {
                        AsyncImage(url: URL(string: item.logoURL!), scale: 3) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }.frame(height: 90)
                        Text(item.prefecture!)
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                    }
                }
            }
            .onDelete(perform: removeFortuneCoreData)
        }
        .navigationBarTitle("", displayMode: .inline)
        .listStyle(.plain)
        .alert("ネットワークエラー", isPresented: $isShowingNetworkError) {
        } message: {
            Text("都道府県の画像を表示するにはインターネットに接続してください。")
        }
        .alert("履歴を全て削除する", isPresented: $isShowingAllDeleteAlert) {
            Button("キャンセル", role: .cancel) {}
            Button("削除する", role: .destructive) {
                deleteAllItems()
            }
        } message: {
            Text("この操作は取り消せません。本当に実行しますか？")
        }
        .alert(errorMessage, isPresented: $isShowingErrorAlert) {
        } message: {
            Text(errorMessageDetail)
        }
        .onAppear {
            if !networkMonitor.isConnected {
                isShowingNetworkError = true
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("履歴")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
            }
        }
        .navigationBarItems(
            trailing: HStack {
                Button(action: {
                    isShowingAllDeleteAlert = true
                }, label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                })
                Menu {
                    Button {
                        sortOrder = "新しい順"
                        resultItems.sortDescriptors = [SortDescriptor(\FortuneResult.createDate, order: .reverse)]
                    } label: {
                        HStack {
                            Text("新しい順")
                            Spacer()
                            if sortOrder == "新しい順" {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    Button {
                        sortOrder = "古い順"
                        resultItems.sortDescriptors = [SortDescriptor(\FortuneResult.createDate, order: .forward)]
                    } label: {
                        HStack {
                            Text("古い順")
                            Spacer()
                            if sortOrder == "古い順" {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    Button {
                        sortOrder = "名前順"
                        resultItems.sortDescriptors = [SortDescriptor(\FortuneResult.userName, order: .forward)]
                    } label: {
                        HStack {
                            Text("名前順")
                            Spacer()
                            if sortOrder == "名前順" {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
            })
    }
    // Date型のデータをString型にする
    private func dateToString(dateString: Date) -> String? {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: dateString)
    }
    private func removeFortuneCoreData(at offsets: IndexSet) {
        for index in offsets {
            let deleteItem = resultItems[index]
            viewContext.delete(deleteItem)
        }
        do {
            try viewContext.save()
        } catch {
            errorMessage = "エラー"
            errorMessageDetail = "データの削除に失敗しました。もう一度お試しください。"
            isShowingErrorAlert = true
        }
    }
    private func deleteAllItems() {
        // Fetchした全てのアイテムを削除
        for item in resultItems {
            viewContext.delete(item)
        }
        do {
            try viewContext.save()
        } catch {
            errorMessage = "エラー"
            errorMessageDetail = "データの削除に失敗しました。もう一度お試しください。"
            isShowingErrorAlert = true
        }
    }
}
