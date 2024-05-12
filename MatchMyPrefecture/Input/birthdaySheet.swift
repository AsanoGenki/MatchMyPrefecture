//
//  birthdaySheet.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import SwiftUI

struct birthdaySheet: View {
    @Binding var birthDay: Date
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            DatePicker(
                "",
                selection: $birthDay,
                displayedComponents: [.date]
            )
            .environment(\.locale, Locale(identifier: "ja_JP"))
            .datePickerStyle(.wheel)
            .labelsHidden()
            
            .navigationBarItems(
                trailing: Button("OK") {
                    dismiss()
                }
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
            )
        }
    }
}

struct birthdaySheet_Previews: PreviewProvider {
    @State static var birthDay: Date = Date()
    static var previews: some View {
        birthdaySheet(birthDay: $birthDay)
    }
}
