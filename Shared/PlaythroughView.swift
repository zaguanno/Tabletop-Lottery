//
//  PlayGameView.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/24/21.
//

import SwiftUI

struct PlaythroughView: View {
    @Binding var game: TabletopGame
    @StateObject var playthroughTimer = PlaythroughTimer()
    @State var currentPlayRating: Double = 0
    @State var newPlaythrough: Playthrough = Playthrough(lengthInMinutes: 0, rating: Rating(0))
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(game.color)
            VStack {
                Spacer()
                ZStack {
                    Circle()
                        .strokeBorder(lineWidth: 24, antialiased: true)
                    VStack {
                        Button(action: {
                            playthroughTimer.reset(averagePlayTimeInMinutes: game.lengthInMinutes)
                            playthroughTimer.startPlaythrough()
                        }) {
                            HStack {
                                Spacer()
                                Label("Start Game", systemImage: "play.fill")
                                Spacer()
                            }
                            .padding()
                        }
                        Spacer()
                        PlaythroughTimerView(minutesElapsed: playthroughTimer.minutesElapsed, secondsElapsed: playthroughTimer.secondsElapsedLessMinutes, averagePlayTimeInSeconds: (playthroughTimer.averagePlayTimeInMinutes * 60), gameColor: game.color)
                        Spacer()
                        Button(action: {
                            playthroughTimer.stopPlaythrough()
                            newPlaythrough = Playthrough(lengthInMinutes: playthroughTimer.minutesElapsed, rating: Rating(currentPlayRating))
                        }) {
                            HStack {
                                Spacer()
                                Label("Stop Game", systemImage: "stop.fill")
                                Spacer()
                            }
                            .padding()
                        }
                    }
                }
                Section(header: Text("Rating")) {
                    HStack {
                        Slider(value: $currentPlayRating, in: 0...5, step: 0.5) {
                            Text("Game Rating")
                        }
                        .accessibilityValue(Text("Rated \(Int(currentPlayRating)) stars"))
                        Text("\(currentPlayRating, specifier: "%.1f")")
                            .accessibilityHidden(true)
                        Image(systemName: "star.fill")
                    }
                    .background(Color.white)
                    .foregroundColor(game.color)
                }
                .padding()
            }
        }
        .padding()
        .foregroundColor(game.color.accessibleFontColor)
        .onAppear {
        }
        .onDisappear {
            if(playthroughTimer.secondsElapsed > 0) {
                newPlaythrough = Playthrough(lengthInMinutes: playthroughTimer.minutesElapsed, rating: Rating(currentPlayRating))
                game.playthroughs.insert(newPlaythrough, at: 0)
                game.recalculateRating()
            }
        }
        .navigationTitle(game.title)
    }
}

struct PlayGameView_Previews: PreviewProvider {
    static var previews: some View {
        PlaythroughView(game: .constant(TabletopGame.data[0]))
    }
}
