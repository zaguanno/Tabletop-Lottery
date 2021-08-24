//
//  LotteryWheelView.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/24/21.
//

import SwiftUI

struct LotteryWheelView: View {
    @Binding var games: [TabletopGame]
    @State private var wheelSpun: Bool = false
    @State private var selectedGame: TabletopGame = TabletopGame(title: "Blank",
                                                                 minimumPlayers: 3,
                                                                 maximumPlayers: 6,
                                                                 lengthInMinutes: 60,
                                                                 color: Color.blue,
                                                                 rating: 1)
    @State private var filter: Filter = Filter(numberOfPlayers: 2, minimumRating: 0)
    var body: some View {
        VStack {
            if wheelSpun {
                List {
                    Spacer()
                    NavigationLink(destination: DetailView(game: binding(for: selectedGame))) {
                        CardView(game: selectedGame)
                    }
                    .listRowBackground(selectedGame.color)
                    Spacer()
                }
            }
            Button {
                selectedGame = spinTheWheel()
                wheelSpun = true
            } label: {
                Text("Spin the Wheel")
                    .padding(20)
            }
            .contentShape(Rectangle())
            .background(Color.green)
        }
    }
    
    private func binding(for game: TabletopGame) -> Binding<TabletopGame> {
        guard let gameIndex = games.firstIndex(where: { $0.id == game.id }) else {
            fatalError("Can't find game in array")
        }
        return $games[gameIndex]
    }
    private func spinTheWheel() -> TabletopGame {
        let gameOptions = games
        
        return gameOptions.randomElement()!
    }
}

struct LotteryWheelView_Previews: PreviewProvider {
    static var previews: some View {
        LotteryWheelView(games: .constant(TabletopGame.data))
    }
}
