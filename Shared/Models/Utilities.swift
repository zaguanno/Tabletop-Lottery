//
//  Utilities.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 9/7/21.
//

import Foundation
import SwiftUI

class MenuBar: ObservableObject, Equatable {
    static func == (lhs: MenuBar, rhs: MenuBar) -> Bool {
        return lhs.tabSelection == rhs.tabSelection
    }
    
    @Published var tabSelection: Int = 2
    init(_ tabSelection: Int = 2) {
        self.tabSelection = tabSelection
    }
    func selectTab(_ tab: Int) {
        self.tabSelection = tab
    }
}

enum GameTypeIcon: String {
    case base = "rectangle.dock", expansion = "plus.rectangle.on.rectangle", variant = "rectangle.on.rectangle.angled.fill"
}

extension Binding {
    func unwrap<Wrapped>() -> Binding<Wrapped>? where Optional<Wrapped> == Value {
        guard let value = self.wrappedValue else { return nil }
        return Binding<Wrapped>(
            get: {
                return value
            },
            set: { value in
                self.wrappedValue = value
            }
        )
    }
}
