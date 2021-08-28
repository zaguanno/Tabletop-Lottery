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
    @State private var noOptions: Bool = false
    @State private var selectedGame: TabletopGame = TabletopGame(title: "No games match your criteria",
                                                                 minimumPlayers: 0,
                                                                 maximumPlayers: 0,
                                                                 lengthInMinutes: 0,
                                                                 color: Color.white,
                                                                 rating: Rating(0))
    @State private var filter: Filter = Filter(numberOfPlayers: 2, minimumRating: 0)
    var body: some View {
        VStack {
            if wheelSpun {
                List {
                    if(noOptions) {
                        HStack {
                            Image(systemName: "exclamationmark.octagon.fill")
                                .foregroundColor(Color.red)
                            Text("No games match your criteria!")
                        }
                    } else {
                        Spacer()
                        NavigationLink(destination: DetailView(game: binding(for: selectedGame), games: $games
                        )) {
                            CardView(game: selectedGame)
                        }
                        .listRowBackground(selectedGame.color)
                        Spacer()
                    }
                }
            }
            HStack {
                VStack {
                    Text("How many players?")
                        .font(.caption)
                    Slider(value: $filter.numberOfPlayers, in: 2...20, step: 1.0) {
                        Text("Minimum Number of Players")
                    }
                    Text("\(Int(filter.numberOfPlayers))")
                }
                Spacer()
                VStack {
                    Text("Minimum star rating?")
                        .font(.caption)
                    Slider(value: $filter.minimumRating, in: 0...5, step: 0.5) {
                        Text("Minimum star rating")
                    }
                    Text("\(filter.minimumRating, specifier: "%.1f")")
                }
            }
            .padding(.horizontal)
            Button {
                spinTheWheel()
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
    private func spinTheWheel() {
        noOptions = false
        let gameOptions = games.filter({(game:TabletopGame) -> Bool in
            return (game.minimumPlayers <= Int(filter.numberOfPlayers) && game.maximumPlayers >= Int(filter.numberOfPlayers)) && game.rating.rating >= filter.minimumRating
        })
        
        let noResults: TabletopGame = TabletopGame(title: "No games match your criteria",
                                     minimumPlayers: 0,
                                     maximumPlayers: 0,
                                     lengthInMinutes: 0,
                                     color: Color.white,
                                     rating: Rating(0))
        if(gameOptions.isEmpty) {
            noOptions = true
        }
        selectedGame = (gameOptions.isEmpty) ? noResults : gameOptions.randomElement()!
    }
}

struct LotteryWheelView_Previews: PreviewProvider {
    static var previews: some View {
        LotteryWheelView(games: .constant(TabletopGame.data))
    }
}
