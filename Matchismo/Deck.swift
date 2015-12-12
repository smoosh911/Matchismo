//
//  Deck.swift
//  Matchismo
//
//  Created by Michael Perry on 9/25/15.
//  Copyright © 2015 Michael Perry. All rights reserved.
//

import Foundation

class Deck {
    
    private lazy var cards = [Card]()
    
    func addCard(card: Card, atTop: Bool) {
        if atTop {
            cards.insert(card, atIndex: 0)
        } else {
            cards.append(card)
        }
    }
    
    func drawRandomCard() -> Card? {
        var randomCard: Card?
        
        if cards.count > 0 {
            let index = Int(arc4random() % UInt32(cards.count))
            randomCard = cards[index]
            cards.removeAtIndex(index)
        }
        return randomCard
    }
}