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
    @State private var filter: Filter = Filter(numberOfPlayers: 2, minimumRating: 0, maximumPlayTime: 60, playthroughState: .allGames)
    var body: some View {
        VStack {
            Image("Playthru_Hero")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.bottom)
            HStack {
                Spacer()
                Text("\(libraryData.activeLibrary.title) Library")
                    .bold()
                    .padding(.trailing)
            }
            Spacer()
            List {
                if(libraryData.activeLibrary.selectedGame == nil) {
                    HStack {
                        Image(systemName: "exclamationmark.octagon.fill")
                            .foregroundColor(Color.red)
                        Text("No games match your criteria!")
                    }
                } else {
                    NavigationLink(destination: DetailView(game: binding(for: libraryData.activeLibrary.selectedGame!), games: $games)) {
                        CardView(game: record(for: libraryData.activeLibrary.selectedGame!))
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    if(libraryData.activeLibrary.selectedGame!.typeIsExpansion) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(Color.yellow)
                            Text("This is an Expansion and requires the Base Game.")
                                .font(.caption)
                        }
                    }
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
                selectGame()
                wheelSpun = true
            } label: {
                Text("Pick for Me")
                    .foregroundColor(Color(hex: "#FDC327"))
                    .bold()
                    .padding(20)
            }
            .background(Color(hex: "#2a27fd"))
            .contentShape(Rectangle())
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding()
        }
        .navigationBarHidden(true)
        .onAppear() {
            
        }
    }
    
    private func binding(for game: TabletopGame) -> Binding<TabletopGame> {
        guard let gameIndex = games.firstIndex(where: { $0.id == game.id }) else {
            fatalError("Can't find game in array")
        }
        return $games[gameIndex]
    }
    private func record(for game: TabletopGame) -> TabletopGame {
        guard let gameIndex = games.firstIndex(where: { $0.id == game.id }) else {
            fatalError("Can't find game in array")
        }
        return games[gameIndex]
    }
    private func selectGame() {
        let gameOptions = filter.filterGameOptions(allGames: games)
        
        libraryData.activeLibrary.selectedGame = gameOptions.randomElement()
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
