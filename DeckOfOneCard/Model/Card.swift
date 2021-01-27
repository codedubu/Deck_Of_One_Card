//
//  Card.swift
//  DeckOfOneCard
//
//  Created by River McCaine on 1/26/21.
//  Copyright © 2021 Warren. All rights reserved.
//

import Foundation

struct TopLevelObject: Codable {
    let cards: [Card]?
}

struct Card: Codable {
    let value: String
    let suit: String
    let image: URL
}
