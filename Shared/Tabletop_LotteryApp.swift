//
//  Tabletop_LotteryApp.swift
//  Shared
//
//  Created by Zachary Smoak on 8/23/21.
//

import SwiftUI

class MenuBar: ObservableObject {
    @Published var tabSelection: Int = 2
    init(_ tabSelection: Int = 2) {
        self.tabSelection = tabSelection
    }
    func selectTab(_ tab: Int) {
        self.tabSelection = tab
    }
}

@main
struct Tabletop_LotteryApp: App {
    @ObservedObject private var gameData = GameData()
    @ObservedObject private var libraryData = LibraryData()
    @ObservedObject private var menuBar = MenuBar()
    var body: some Scene {
        WindowGroup {
            //NavigationView {
                //GamesView(games: $gameData.games) {
                //    gameData.save()
                //}
                MenuBarView(libraries: $libraryData.libraries, games: $gameData.games) {
                    libraryData.save()
                }
                .environmentObject(libraryData)
                .environmentObject(menuBar)
            //}
            //.navigationViewStyle(StackNavigationViewStyle())
            .onAppear() {
                libraryData.load()
                gameData.load()
            }
        }
    }
}
