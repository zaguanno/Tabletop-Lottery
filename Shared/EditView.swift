//
//  EditView.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/23/21.
//

import CodeScanner
import SwiftUI
import URLImage

struct EditView: View {
    @Binding var gameData: TabletopGame.Data
    @Binding var games: [TabletopGame]
    @Binding var isNewGame: Bool
    @State private var isShowingScanner: Bool = false
    @State private var isShowingErrorAlert: Bool = false
    @State private var scanningErrorMessage: String = ""
    @State private var scanResults: ScanResult = ScanResult()
    @State private var isSelectingNewImage: Bool = false
    @State var newImageURLString: String = ""
    var body: some View {
        List {
            Section(header: Text("Game Image")) {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            isSelectingNewImage = true
                        }) {
                            VStack {
                                ZStack {
                                    if gameData.imageURLString != "" {
                                        URLImage(URL(string: gameData.imageURLString)!) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 150, height: 150)
                                        }
                                    } else {
                                        Image(systemName: "cube.box.fill")
                                            .frame(width: 150, height: 150)
                                    }
                                    if !isSelectingNewImage {
                                        Text("Upload new image...")
                                            .padding(.top, 130)
                                            .padding(.horizontal)
                                            .padding(.bottom, 10)
                                            .background(Color.gray.opacity(0.5))
                                            .font(.headline)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    if isSelectingNewImage {
                        HStack {
                            Image(systemName: "photo")
                            TextField("Image URL", text: $gameData.imageURLString)
                                .padding()
                            Button("Done") {
                                isSelectingNewImage = false
                            }
                        }
                    }
                }
            }
            Section(header: Text("Game Info")) {
                TextField("Title", text: $gameData.title)
                HStack {
                    VStack {
                        Text("Base Game")
                            .font(.caption)
                        HStack {
                            Image(systemName: "rectangle")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            Toggle("", isOn: $gameData.typeIsBase)
                        }
                    }
                    Spacer()
                    VStack {
                        Text("Expansion")
                            .font(.caption)
                        HStack {
                            Image(systemName: "plus.rectangle.on.rectangle")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            Toggle("", isOn: $gameData.typeIsExpansion)
                        }
                    }
                    Spacer()
                    VStack {
                        Text("Variant")
                            .font(.caption)
                        HStack {
                            Image(systemName: "rectangle.on.rectangle.angled.fill")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            Toggle("", isOn: $gameData.typeIsVariant)
                        }
                    }
                }
                //TODO: Picker for connecting Expansion to Base
               /*if gameData.typeIsExpansion {
                    HStack {
                        VStack {
                            Picker("Base Game", selection: $gameData.baseGameID) {
                                ForEach(games.filter({$0.typeIsBase})) {game in
                                    Text("\(game.title)").tag(game.baseGameID)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            Text("suggestedTopping: \(gameData.baseGameID)")
                        }
                    }
                }*/
                HStack {
                    Slider(value: $gameData.lengthInMinutes, in: 5...120, step: 1.0) {
                        Text("Length")
                    }
                    .accessibilityValue(Text("\(Int(gameData.lengthInMinutes)) minutes"))
                    Spacer()
                    Text("\(Int(gameData.lengthInMinutes)) minutes")
                        .accessibilityHidden(true)
                }
                ColorPicker("Color", selection: $gameData.color)
                    .accessibilityLabel(Text("Color picker"))
            }
            Section(header: Text("Number of Players")) {
                HStack {
                    Text("Min \(Int(gameData.minimumPlayers))")
                        .accessibilityHidden(true)
                        .font(.caption)
                    Slider(value: $gameData.minimumPlayers, in: 2...gameData.maximumPlayers, step: 1.0) {
                        Text("Minimum Number of Players")
                    }
                    .accessibilityValue(Text("\(Int(gameData.minimumPlayers)) players minimum"))
                    Spacer()
                    Slider(value: $gameData.maximumPlayers, in: gameData.minimumPlayers...20, step: 1.0) {
                        Text("Minimum Number of Players")
                    }
                    .accessibilityValue(Text("\(Int(gameData.maximumPlayers)) players maximum"))
                    Text("\(Int(gameData.maximumPlayers)) Max")
                        .accessibilityHidden(true)
                        .font(.caption)
                }
            }
            Section(header: Text("Rating")) {
                HStack {
                    Slider(value: $gameData.rating, in: 0...5, step: 0.5) {
                        Text("Game Rating")
                    }
                    .accessibilityValue(Text("Rated \(Int(gameData.rating)) stars"))
                    Text("\(gameData.rating, specifier: "%.1f")")
                        .accessibilityHidden(true)
                    Image(systemName: "star.fill")
                }
            }
            Button(action: {
                let scan = ScanResult()
                scan.searchByName(gameTitle: gameData.title) { scanResult in
                    self.gameData.title = scan.gameTitle
                    switch scanResult {
                    case .failure(let scanError):
                        scanningErrorMessage = scan.errorMessage(error: scanError).replacingOccurrences(of: ".gameTitle", with: scan.gameTitle)
                        self.isShowingErrorAlert = true
                    case .success(let scannedGame):
                        gameData.lengthInMinutes = Double(scannedGame.playingtime)
                        gameData.minimumPlayers = Double(scannedGame.minplayers)
                        gameData.maximumPlayers = Double(scannedGame.maxplayers)
                        if scanResults.gameDetails.image != "" {
                            gameData.imageURLString = scannedGame.image
                        }
                    }
                }
            }) {
                HStack {
                    Spacer()
                    Label("Lookup Game Info", systemImage: "doc.text.magnifyingglass")
                    Spacer()
                }
                .padding()
            }
            .alert(isPresented: $isShowingErrorAlert) {
                Alert(title: Text("Lookup Error"), message: Text("\(scanningErrorMessage)"), dismissButton: .default(Text("Got it!")))
            }
            if isNewGame {
                HStack(alignment: .center) {
                    Spacer()
                    Button(action: {
                        isShowingScanner = true
                    }) {
                        Label("Scan a Barcode", systemImage: "barcode.viewfinder")
                    }
                    .alert(isPresented: $isShowingErrorAlert) {
                        Alert(title: Text("Scanning Error"), message: Text("\(scanningErrorMessage)"), dismissButton: .default(Text("Got it!")))
                    }
                    Spacer()
                }
                Section(header: Text("Scanning Data")) {
                    VStack {
                        Text("UPC: \(scanResults.rawScanData)")
                        Divider()
                        Text("Game Title: \(scanResults.gameTitle)")
                        Divider()
                        Text("Play Time: \(scanResults.gameDetails.playingtime)")
                        Divider()
                        Text("Min Players: \(scanResults.gameDetails.minplayers)")
                        Divider()
                        Text("Max Players: \(scanResults.gameDetails.maxplayers)")
                        if scanResults.gameDetails.image != "" {
                            Divider()
                            let gameImageUrl: URL = URL(string: scanResults.gameDetails.image)!
                            URLImage(gameImageUrl) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                        
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr,.code39,.code39Mod43,.code93,.code128,.ean8,.ean13,.interleaved2of5,.itf14,.upce], simulatedData: "3558380029564", completion: handleScan)
            // 3770001556185 (Tokaido)
            // 824968717912 (Ticket to Ride)
            // 3558380029564 (Mysterium)
        }
        
        

    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            let scan = ScanResult(rawScanData: code)
            scan.searchByCode() { scanResult in
                gameData.title = scan.gameTitle
                switch scanResult {
                case .failure(let scanError):
                    scanningErrorMessage = scan.errorMessage(error: scanError).replacingOccurrences(of: ".gameTitle", with: scan.gameTitle)
                    self.isShowingErrorAlert = true
                case .success(let scannedGame):
                    gameData.lengthInMinutes = Double(scannedGame.playingtime)
                    gameData.minimumPlayers = Double(scannedGame.minplayers)
                    gameData.maximumPlayers = Double(scannedGame.maxplayers)
                    if scanResults.gameDetails.image != "" {
                        gameData.imageURLString = scannedGame.image
                    }
                }
            }

            scanResults = scan
        case .failure(_):
            print("Scanning failed")
            self.isShowingScanner = false
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(gameData: .constant(TabletopGame.data[2].data), games: .constant(TabletopGame.data), isNewGame: .constant(false))
    }
}
