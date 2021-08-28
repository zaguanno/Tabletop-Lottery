//
//  CardView.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/23/21.
//

import SwiftUI
import URLImage

struct CardView: View {
    let game: TabletopGame
    var body: some View {
        HStack {
            if game.imageURLString != "" {
                URLImage(game.imageURL()) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }
            } else {
                Image(systemName: "cube.box.fill")
                    .frame(width: 50, height: 50)
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(game.title)
                        .font(.headline)
                    Spacer()
                    game.rating.ratingView()
                    .font(.caption)
                }
                Spacer()
                HStack {
                    if game.typeIsBase {
                        Image(systemName: "rectangle")
                    } else {
                        if game.typeIsExpansion { Image(systemName: "plus.rectangle.on.rectangle") }
                        if game.typeIsVariant { Image(systemName: "rectangle.on.rectangle.angled.fill") }
                    }
                    Spacer()
                    Label("\(game.minimumPlayers) - \(game.maximumPlayers)", systemImage: "person.3")
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(Text("Number of Players"))
                        .accessibilityValue(Text("\(game.minimumPlayers) to \(game.maximumPlayers)"))
                    Spacer()
                    Label("\(game.lengthInMinutes)", systemImage: "clock")
                        .padding(.trailing, 20)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(Text("Game length"))
                        .accessibilityValue(Text("\(game.lengthInMinutes) minutes"))
                }
                .font(.caption)
            }
        }
        .padding(.top)
        .padding(.bottom)
        .padding(.trailing)
        .foregroundColor(game.color.accessibleFontColor)
    }
}

struct CardView_Previews: PreviewProvider {
    static var game = TabletopGame.data[2]
    static var previews: some View {
        CardView(game: game)
            .background(game.color)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
