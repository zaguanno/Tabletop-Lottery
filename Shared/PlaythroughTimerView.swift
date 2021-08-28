//
//  PlaythroughTimerView.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/28/21.
//

import SwiftUI

struct PlaythroughTimerView: View {
    let hoursElapsed: Int = 0
    let minutesElapsed: Int
    let secondsElapsed: Int
    let averagePlayTimeInSeconds: Int
    private var progress: Double {
        return Double(secondsElapsed) / Double(averagePlayTimeInSeconds)
    }
    private var minutesRemaining: Int {
        averagePlayTimeInSeconds / 60
    }
    private var minutesRemainingMetric: String {
        minutesRemaining == 1 ? "minute" : "minutes"
    }
    let gameColor: Color
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.black)
                VStack {
                    HStack {
                        Image(systemName: "hourglass.bottomhalf.fill")
                        Text("\(hoursElapsed, specifier: "%02d")")
                        Spacer()
                        Text(":")
                        Spacer()
                        Text("\(minutesElapsed, specifier: "%02d")")
                        Spacer()
                        Text(":")
                        Spacer()
                        Text("\(secondsElapsed, specifier: "%02d")")
                    }
                    .font(.largeTitle)
                    .foregroundColor(gameColor)
                    ProgressView(value: progress)
                        .progressViewStyle(PlaythroughProgressViewStyle(gameColor: gameColor))
                    Spacer()
                }
                .padding()
            }
            
        }
        .padding(.horizontal)
        .frame(height: 125)
    }
}

struct PlaythroughTimerView_Previews: PreviewProvider {
    static var previews: some View {
        PlaythroughTimerView(minutesElapsed: 10, secondsElapsed: 20, averagePlayTimeInSeconds: 180, gameColor: TabletopGame.data[0].color)
            .previewLayout(.sizeThatFits)
    }
}
