//
//  ButtonUIView.swift
//  MatchMyPrefecture
//
//  Created by Genki on 5/12/24.
//

import SwiftUI

struct ButtonUIView: View {
    var text: String
    var color: Color
    var backColor: Color
    var body: some View {
        ZStack {
            Text("  ")
                .frame(minWidth: 150)
                .foregroundColor(.white)
                .font(.system(.title2, design: .rounded).bold())
                .padding()
                .background(RoundedRectangle(cornerRadius: 100).fill(backColor.opacity(1)))
                .padding(.top, 14)
            
            Text(text)
                .frame(minWidth: 150)
                .foregroundColor(.white)
                .font(.system(size: 23))
                .fontWeight(.semibold)
                .padding()
                .background(RoundedRectangle(cornerRadius: 100).fill(color.opacity(1)))
            
        }
    }
}

struct ButtonUIView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonUIView(text: "テキスト", color: .blue, backColor: .yellow)
    }
}
