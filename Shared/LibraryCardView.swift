//
//  LibraryCardView.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 9/1/21.
//

import SwiftUI
import URLImage

struct LibraryCardView: View {
    let library: Library
    var body: some View {
        VStack {
            Rectangle()
                .fill(library.color)
                .frame(height: 5)
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(library.title)
                            .font(.headline)
                        Spacer()
                        Text("\(library.games.count) games")
                    }
                }
            }
            .padding([.leading, .trailing])
        }
        .contentShape(Rectangle())
        .padding(.bottom)
    }
}

struct LibraryCardView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryCardView(library: Library.data[1])
            .previewLayout(.fixed(width: 400, height: 75))
    }
}
