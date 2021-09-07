//
//  Tabletop_LotteryApp.swift
//  Shared
//
//  Created by Zachary Smoak on 8/23/21.
//

import SwiftUI

@main
struct Tabletop_LotteryApp: App {
    @ObservedObject private var libraryData = LibraryData()
    @ObservedObject private var menuBar = MenuBar()
    var body: some Scene {
        WindowGroup {
            MenuBarView(libraries: $libraryData.libraries) {
                libraryData.save()
            }
            .environmentObject(libraryData)
            .environmentObject(menuBar)
            .onAppear() {
                libraryData.load()
            }
        }
    }
}
