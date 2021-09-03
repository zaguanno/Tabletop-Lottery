//
//  LotteryWheelView.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/24/21.
//

import SwiftUI

struct LotteryWheelView: View {
    @EnvironmentObject var libraryData: LibraryData
    @Binding var games: [TabletopGame]
    @State private var wheelSpun: Bool = false
    @State private var noOptions: Bool = false
    @State private var selectedGame: TabletopGame = TabletopGame(title: "No games match your criteria",
                                                                 minimumPlayers: 0,
                                                                 maximumPlayers: 0,
                                                                 lengthInMinutes: 0,
                                                                 color: Color.white,
                                                                 rating: Rating(0))
    @State private var filter: Filter = Filter(numberOfPlayers: 2, minimumRating: 0, maximumPlayTime: 60, playthroughState: .allGames)
    var body: some View {
        VStack {
            List {
                if(noOptions) {
                    HStack {
                        Image(systemName: "exclamationmark.octagon.fill")
                            .foregroundColor(Color.red)
                        Text("No games match your criteria!")
                    }
                } else {
                    NavigationLink(destination: DetailView(game: $selectedGame, games: $games)) {
                        CardView(game: selectedGame)
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .opacity(wheelSpun ? 1 : 0)
            VStack {
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
                .padding(.vertical)
                HStack {
                    Picker(selection: $filter.playthroughState, label: Text("")) {
                        Text("New Games").tag(PlaythroughState.newGamesOnly)
                        Text("All Games").tag(PlaythroughState.allGames)
                        Text("Played Games").tag(PlaythroughState.playedGamesOnly)
                    }.pickerStyle(SegmentedPickerStyle())
                }
                HStack {
                    VStack {
                        Text("How long do you want to play?")
                            .font(.caption)
                        Slider(value: $filter.maximumPlayTime, in: 5...120, step: 1.0) {
                            Text("Maximum Play Time")
                        }
                        Text("\(Int(filter.maximumPlayTime)) mins")
                    }
                }
                .padding(.vertical)
            }
            .padding(.horizontal)
            Button {
                spinTheWheel()
                wheelSpun = true
            } label: {
                Text("Spin the Wheel")
                    .padding(20)
            }
            .background(Color.green)
            .contentShape(Rectangle())
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding()
        }
        .navigationTitle("\(libraryData.activeLibrary.title)")
        .onAppear() {
            wheelSpun = false
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
        let gameOptions = filter.filterGameOptions(allGames: games)
        
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
        let libraryData: LibraryData = LibraryData()
        LotteryWheelView(games: .constant(TabletopGame.data))
            .environmentObject(libraryData)
            .onAppear() {
                libraryData.load()
            }
    }
}
