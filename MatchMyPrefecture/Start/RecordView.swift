//
//  RecordView.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import SwiftUI
import CoreData

struct RecordView: View {
    @FetchRequest(sortDescriptors: [])
    var resultItems: FetchedResults<FortuneResult>
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    @State private var showNetworkError = false
    var body: some View {
        List {
            ForEach(resultItems, id: \.self) { item in
                HStack {
                    VStack (alignment: .leading, spacing: 5) {
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
        .alert("ネットワークエラー", isPresented: $showNetworkError) {
        } message: {
            Text("都道府県の画像を表示するにはインターネットに接続してください。")
        }
        .onAppear {
            if !networkMonitor.isConnected {
                showNetworkError = true
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("履歴")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
            }
            
        }
    }
    // Date型のデータをString型にする
    func dateToString(dateString: Date) -> String? {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: dateString)
    }
    func removeFortuneCoreData(at offsets: IndexSet) {
        for index in offsets {
            let deleteItem = resultItems[index]
            viewContext.delete(deleteItem)
        }
        do {
            try viewContext.save()
        } catch {
            fatalError("セーブに失敗")
        }
    }
}
