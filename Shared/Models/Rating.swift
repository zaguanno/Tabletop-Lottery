//
//  Rating.swift
//  Tabletop Lottery
//
//  Created by Zachary Smoak on 8/27/21.
//

import Foundation
import SwiftUI

struct Rating: Identifiable, Codable {
    let id: UUID
    var rating: Double

    init(id: UUID = UUID(), _ rating: Double) {
        self.id = id
        self.rating = rating
    }
    
    func ratingView() -> some View {
        return rView(rating: self.rating)
    }
    
    struct rView: View {
        var rating: Double
        var body: some View {
            HStack {
                (rating >= 1) ? Image(systemName: "star.fill") : Image(systemName: "star")
                (rating >= 2) ? Image(systemName: "star.fill") : Image(systemName: "star")
                (rating >= 3) ? Image(systemName: "star.fill") : Image(systemName: "star")
                (rating >= 4) ? Image(systemName: "star.fill") : Image(systemName: "star")
                (rating >= 5) ? Image(systemName: "star.fill") : Image(systemName: "star")
            }
        }
    }
}
