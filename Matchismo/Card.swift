//
//  Card.swift
//  Matchismo
//
//  Created by Michael Perry on 9/25/15.
//  Copyright © 2015 Michael Perry. All rights reserved.
//

import Foundation

class Card {
    var contents = ""
    var faceUp = false
    var playable = true
    
    func match(otherCards: [Card]) -> Int {
        var score = 0
        
        for card in otherCards {
            if card.contents == contents {
                score = 1
                break
            }
        }
        
        return score
    }
}
