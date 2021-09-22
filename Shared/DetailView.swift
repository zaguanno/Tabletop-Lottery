//
//  DetailView.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/23/21.
//

import SwiftUI
import URLImage

struct DetailView: View {
    @Binding var game: TabletopGame
    @Binding var games: [TabletopGame]
    @State private var data: TabletopGame.Data = TabletopGame.Data()
    @State private var isPresented = false
    @State private var isNewGame = false
    
    var body: some View {
        List {
            HStack {
                if game.imageURLString != "" {
                    URLImage(game.imageURL()) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                    }
                } else {
                    Image(systemName: "cube.box.fill")
                        .frame(width: 150, height: 150)
                }
                Spacer()
                game.rating.ratingView()
            }
            NavigationLink(destination: PlaythroughView(game: $game)) {
                HStack {
                    Spacer()
                    Label("Play Game", systemImage: "play.rectangle")
                        .font(.headline)
                    Spacer()
                }
                .padding()
            }
            Section(header: Text("Game Info")) {
                HStack {
                    VStack {
                        Image(systemName: GameTypeIcon.base.rawValue)
                        Text("Base Game")
                            .font(.caption)
                    }
                    .padding(10)
                    .background(game.typeIsBase ? Color.green : Color.gray)
                    .opacity(game.typeIsBase ? 1 : 0.25)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    Spacer()
                    VStack {
                        Image(systemName: GameTypeIcon.expansion.rawValue)
                        Text("Expansion")
                            .font(.caption)
                    }
                    .padding(10)
                    .background(game.typeIsExpansion ? Color.green : Color.gray)
                    .opacity(game.typeIsExpansion ? 1 : 0.25)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    Spacer()
                    VStack {
                        Image(systemName: GameTypeIcon.variant.rawValue)
                        Text("  Variant  ")
                            .font(.caption)
                    }
                    .padding(10)
                    .background(game.typeIsVariant ? Color.green : Color.gray)
                    .opacity(game.typeIsVariant ? 1 : 0.25)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                if(game.baseGameID != nil) {
                    let baseGame = games.filter({$0.id == game.baseGameID})[0]
                    NavigationLink(destination: DetailView(game: binding(for: baseGame), games: $games)) {
                        HStack {
                            Label("Base Game", systemImage: GameTypeIcon.base.rawValue)
                            Spacer()
                            Text("\(baseGame.title)")
                        }
                    }
                }
                HStack {
                    Label("Number of Players", systemImage: "person.3")
                        .accessibilityLabel(Text("Number of players"))
                    Spacer()
                    Text("\(game.minimumPlayers) - \(game.maximumPlayers)")
                }
                HStack {
                    Label("Length", systemImage: "clock")
                        .accessibilityLabel(Text("Game length"))
                    Spacer()
                    Text("\(game.lengthInMinutes) minutes")
                }
                HStack {
                    Label("Color", systemImage: "paintpalette")
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(game.color)
                }
                .accessibilityElement(children: .ignore)
            }
            Section(header: Text("Playthroughs")) {
                if game.playthroughs.isEmpty {
                    Label("This game hasn't been played yet.", systemImage: "calendar.badge.exclamationmark")
                }
                ForEach(game.playthroughs) {playthrough in
                    HStack {
                        Image(systemName: "calendar")
                        Text(playthrough.date, style: .date)
                        Spacer()
                        VStack {
                            playthrough.rating.ratingView()
                            Text("\(playthrough.lengthInMinutes) mins")
                        }
                        .font(.caption)
                    }
                }
            }
            Section(header: Text("Expansions")) {
                let expansions = games.filter({$0.baseGameID == game.id})
                if expansions.isEmpty {
                    Label("This game has no expansions", systemImage: GameTypeIcon.expansion.rawValue)
                }
                ForEach(expansions) {expansion in
                    HStack {
                        NavigationLink(destination: DetailView(game: binding(for: expansion), games: $games)) {
                            HStack {
                                Label("\(expansion.title)", systemImage: GameTypeIcon.expansion.rawValue)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarItems(trailing: Button("Edit") {
            isPresented = true
            data = game.data
        })
        .navigationTitle(game.title)
        .fullScreenCover(isPresented: $isPresented) {
            NavigationView {
                EditView(gameData: $data, games: $games, isNewGame: $isNewGame)
                    .navigationTitle(game.title)
                    .navigationBarItems(leading: Button("Cancel") {
                        isPresented = false
                    }, trailing: Button("Done") {
                        isPresented = false
                        game.update(from: data)
                    })
            }
        }
    }
    
    private func binding(for game: TabletopGame) -> Binding<TabletopGame> {
        guard let gameIndex = games.firstIndex(where: { $0.id == game.id }) else {
            fatalError("Can't find game in array")
        }
        return $games[gameIndex]
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(game: .constant(TabletopGame.data[0]), games: .constant(TabletopGame.data))
        }
    }
}
