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
        VStack {
            Rectangle()
                .fill(game.color)
                .frame(height: 5)
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
                            Image(systemName: GameTypeIcon.base.rawValue)
                        } else {
                            if game.typeIsExpansion { Image(systemName: GameTypeIcon.expansion.rawValue) }
                            if game.typeIsVariant { Image(systemName: GameTypeIcon.variant.rawValue) }
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
            .padding([.leading, .trailing])
        }
        .padding(.bottom)
    }
}

struct CardView_Previews: PreviewProvider {
    static var game = TabletopGame.data[2]
    static var previews: some View {
        CardView(game: game)
            .previewLayout(.fixed(width: 400, height: 75))
    }
}
