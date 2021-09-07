//
//  LibraryData.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 9/1/21.
//

import Foundation

class LibraryData: ObservableObject {
    private static var documentsFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    private static var fileURL: URL {
        return documentsFolder.appendingPathComponent("library.data")
    }
    @Published var libraries: [Library] = [] {
        willSet {
            objectWillChange.send()
            self.save()
        }
    }
    @Published var activeLibrary: Library = Library(dummy: true) {
        willSet {
            objectWillChange.send()
            updateLibraryDetails(library: self.activeLibrary)
            self.save()
            #if DEBUG
            //check for save errors here
            #endif
        }
    }
    
    init() {
        //self.activateLibrary(library: self.libraries[0])
    }
    
    func load() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.fileURL) else {
                print("New App State.")
                print("..Defaulting to Empty Library State.")
                DispatchQueue.main.async {
                    self?.libraries = [Library(title: "My Game Library")]
                    
                    #if DEBUG
                        print("..Prepopulating with Test Data.")
                        self?.libraries = Library.data
                    #endif
                    
                    self?.activateLibrary(library: (self?.libraries[0])!)
                }
                return
            }
            guard let gameLibraries = try? JSONDecoder().decode([Library].self, from: data) else {
                print("Can't decode saved library data.")
                print("..Defaulting to Empty Library State.")
                DispatchQueue.main.async {
                    self?.libraries = [Library(title: "My Game Library")]
                    
                    #if DEBUG
                        print("..Prepopulating with Test Data.")
                        self?.libraries = Library.data
                    #endif
                    
                    self?.activateLibrary(library: (self?.libraries[0])!)
                }
                return
            }
            DispatchQueue.main.async {
                self?.libraries = gameLibraries
                self?.activateLibrary(library: (self?.libraries[0])!)
            }
        }
    }
    
    func getLibraryIndex(library: Library) -> Int {
        guard let libraryIndex = self.libraries.firstIndex(where: { $0.id == library.id }) else {
            fatalError("Can't find library in array")
        }
        return libraryIndex
    }
    
    func activateLibrary(library: Library) {
        updateLibraryDetails(library: self.activeLibrary)
        
        self.activeLibrary = self.libraries[getLibraryIndex(library: library)]
    }
    
    func updateLibraryDetails(library: Library) {
        if(!self.activeLibrary.dummy) {
            self.libraries[getLibraryIndex(library: library)].updateDetails(library)
        }
    }
    
    func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let libraries = self?.libraries else { fatalError("Self out of scope") }
            guard let data = try? JSONEncoder().encode(libraries) else { fatalError("Error encoding data") }
            do {
                let outfile = Self.fileURL
                try data.write(to: outfile)
            } catch {
                fatalError("Can't write to file")
            }
        }
    }
}
