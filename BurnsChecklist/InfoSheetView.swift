//
//  InfoSheetView.swift
//  BurnsChecklist
//
//  Created by robert on 8/22/23.
//

import SwiftUI

struct InfoSheetView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(.black)
            VStack {
                Text("For personal use only. \nThis work is probably copyright by David D. Burns, MD, and has been used without permission.")
                    .font(.title2)
                    .padding(.top, 80)
                    .onTapGesture {
                        dismiss()
                    }
                Spacer()
                Text("Please visit the website of David D. Burns, MD at [feelinggood.com](https://feelinggood.com)")
                    .font(.footnote)
            }
            .padding()
            .foregroundColor(.white)
            .frame(width: 400, height: 400)
            .background(Image("Icon-256")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            )
            .padding()
        }
    }
}

struct InfoSheetView_Previews: PreviewProvider {
    static var previews: some View {
        InfoSheetView()
    }
}
