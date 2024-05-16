//
//  bloodTypeSheet.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import SwiftUI

struct BloodTypeSheet: View {
    @Binding var bloodType: String
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            Picker(selection: $bloodType, label: Text("血液型")) {
                Text("A型").tag("A型")
                Text("B型").tag("B型")
                Text("AB型").tag("AB型")
                Text("O型").tag("O型")
            }
            .font(.system(size: 18))
            .fontWeight(.semibold)
            .pickerStyle(WheelPickerStyle())
            .navigationBarItems(
                trailing: Button("OK") {
                    dismiss()
                }
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
            )
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct BloodTypeSheet_Previews: PreviewProvider {
    @State static var bloodType: String = "A型"
    static var previews: some View {
        BloodTypeSheet(bloodType: $bloodType)
    }
}
