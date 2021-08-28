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
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(game.color)
            VStack {
                Spacer()
                PlaythroughTimerView(minutesElapsed: playthroughTimer.minutesElapsed, secondsElapsed: playthroughTimer.secondsElapsedLessMinutes, averagePlayTimeInSeconds: (playthroughTimer.averagePlayTimeInMinutes * 60), gameColor: game.color)
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
                .padding(.top)
                Circle()
                    .strokeBorder(lineWidth: 24, antialiased: true)
            }
        }
        .padding()
        .foregroundColor(game.color.accessibleFontColor)
        .onAppear {
            playthroughTimer.reset(averagePlayTimeInMinutes: game.lengthInMinutes)
            playthroughTimer.startPlaythrough()
        }
        .onDisappear {
            playthroughTimer.stopPlaythrough()
            let newPlaythrough = Playthrough(lengthInMinutes: 0, rating: Rating(currentPlayRating))
            game.playthrough.insert(newPlaythrough, at: 0)
            game.recalculateRating()
        }
        .navigationTitle(game.title)
    }
}

struct PlayGameView_Previews: PreviewProvider {
    static var previews: some View {
        PlaythroughView(game: .constant(TabletopGame.data[0]))
    }
}
