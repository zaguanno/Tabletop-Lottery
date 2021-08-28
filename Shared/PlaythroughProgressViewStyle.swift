//
//  PlaythroughProgressView.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/28/21.
//

import SwiftUI

struct PlaythroughProgressViewStyle: ProgressViewStyle {
    var gameColor: Color

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .fill(gameColor.accessibleFontColor)
                .frame(height: 20.0)
            ProgressView(configuration)
                .frame(height: 12.0)
                .padding(.horizontal)
        }
    }
}
