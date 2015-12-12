//
//  PlayingCard.swift
//  Matchismo
//
//  Created by Michael Perry on 9/25/15.
//  Copyright © 2015 Michael Perry. All rights reserved.
//

import Foundation

class PlayingCard: Card {
    private static let RANK_MATCH_SCORE = 5
    private static let SUIT_MATCH_SCORE = 2
    
    private static let THREE_RANK_MATCH_SCORE = 20
    private static let THREE_SUIT_MATCH_SCORE = 8
    
    var suit: String! {
        didSet {
            if !PlayingCard.validSuits().contains(suit) {
                suit = "?"
            }
            updateContents()
        }
    }
    
    var rank: Int! {
        didSet {
            if rank < 0 || rank > PlayingCard.maxRank() {
                rank = 0
            }
            updateContents()
        }
    }
    
    //Check multiple cards to see if they match. It either compares two or three cards
    override func match(otherCards: [Card]) -> Int {
        var score = 0
        
        if otherCards.count == 1 {
            if let otherCard = otherCards.last as? PlayingCard {
                if otherCard.suit == suit {
                    score = PlayingCard.SUIT_MATCH_SCORE
                } else if otherCard.rank == rank {
                    score = PlayingCard.RANK_MATCH_SCORE
                }
            }
        } else if otherCards.count == 2 {
            if let otherCard = otherCards[0] as? PlayingCard {
                if let otherCard2 = otherCards[1] as? PlayingCard {
                    if otherCard.suit == suit && otherCard.suit == otherCard2.suit {
                        score = PlayingCard.THREE_SUIT_MATCH_SCORE
                    } else if otherCard.rank == rank && otherCard.rank == otherCard2.rank {
                        score = PlayingCard.THREE_RANK_MATCH_SCORE
                    }
                }
            }
        }
        return score
    }
    private class func rankStrings() -> [String] {
        return ["?", "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    }
    //This "contents" value is used accross the app to display rank and suite together
    private func updateContents() {
        contents = "\(PlayingCard.rankStrings()[rank])\(suit)"
    }
    
    class func validSuits() -> [String] {
        return ["♥","♦","♠","♣"]
    }
    
    class func maxRank() -> Int {
        return rankStrings().count - 1
    }
}