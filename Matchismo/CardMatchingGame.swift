//
//  CardMatchingGame.swift
//  Matchismo
//
//  Created by Michael Perry on 9/28/15.
//  Copyright © 2015 Michael Perry. All rights reserved.
//

import Foundation

class CardMatchingGame {
    private static let FLIP_COST = 1
    private static let MATCH_BONUS = 5
    private static let MISMATCH_PENALTY = 2
    
    private var score = 0
    private var cards = [Card]()
    private var flipResults = "Flip to start a game!"
    
    private var whenScoreLastUpdated = NSDate()
    private var whenGameStarted = NSDate()
    private var dateFormatter = NSDateFormatter()
    
    private var flipResultsStringPosted = false
    
    init (cardCount: Int, deck: Deck) {
        for _ in 0 ..< cardCount {
            if let card = deck.drawRandomCard() {
                cards.append(card)
            }
        }
    }
    
    func cardAtIndex(index: Int) -> Card? {
        if index >= 0 && index < cards.count {
            return cards[index]
        }
        return nil
    }
    
    func flipCardAtIndex(index: Int) {
        var twoCardsPlayable: Bool = false
        var cardsPlayableAndFacedUp: Int = 0
        for aCard in cards {
            if aCard.playable && aCard.faceUp {
                cardsPlayableAndFacedUp++
            }
            if cardsPlayableAndFacedUp > 1 {
                twoCardsPlayable = true
            }
        }
        
        if let card = cardAtIndex(index) {
            if card.playable {
                if !card.faceUp {
                    if !twoCardsPlayable {
                        for otherCard in cards {
                            if otherCard.faceUp && otherCard.playable {
                                let matchScore = card.match([otherCard])
                                // match tells how much the match is, or 0 if match
                                if matchScore > 0 {
                                    otherCard.playable = false
                                    card.playable = false
                                    score += matchScore + CardMatchingGame.MATCH_BONUS
                                    if !flipResultsStringPosted {
                                        flipResults = "Matched \(card.contents) & \(otherCard.contents): \(matchScore + CardMatchingGame.MATCH_BONUS - 1) points"
                                        flipResultsStringPosted = true
                                    }
                                } else {
                                    score -= CardMatchingGame.MISMATCH_PENALTY
                                    if !flipResultsStringPosted {
                                        flipResults = "\(card.contents) & \(otherCard.contents) don't match: \(-CardMatchingGame.MISMATCH_PENALTY - 1) points"
                                        flipResultsStringPosted = true
                                    }
                                }
                                // we've found the other face-up playable card, so stop looking
                                break
                            }
                        }
                        score -= CardMatchingGame.FLIP_COST
                        if !flipResultsStringPosted {
                            flipResults = "Flipped up \(card.contents): normal -\(CardMatchingGame.FLIP_COST) flip cost"
                        }
                        flipResultsStringPosted = false
                    } else {
                        flipResults = "Too many cards flipped over!"
                        card.faceUp = !card.faceUp
                    }
                }
                card.faceUp = !card.faceUp
            }
        }
    }
    
    //This is the flip card function called whenever the game is set to 3 card matching setting
    func flipCardAtIndexThreeCards(index: Int) {
        var threeCardsPlayable: Bool = false
        var cardsPlayableAndFacedUp: Int = 0
        //checks if there are three cards playable and faceup (if there are three the program won't let the user flip anymore cards over)
        for aCard in cards {
            if aCard.playable && aCard.faceUp {
                cardsPlayableAndFacedUp++
            }
            if cardsPlayableAndFacedUp > 2 {
                threeCardsPlayable = true
            }
        }
        //grab card just flipped over
        if let card = cardAtIndex(index) {
            if card.playable {
                if !card.faceUp {
                    //make sure there isn't more than three cards
                    if !threeCardsPlayable {
                        for otherCard in cards {
                            if otherCard.faceUp && otherCard.playable {
                                let matchScore = card.match([otherCard])
                                // match tells how much the match is, or 0 if no match
                                //grab third possible value and compare to previous two
                                for otherCard2 in cards {
                                    //make sure the thrid card is different from the previous two
                                    if otherCard2.faceUp && otherCard2.playable && otherCard.contents != otherCard2.contents && otherCard2.contents != card.contents {
                                        //check for match with first two cards
                                        if matchScore > 0 {
                                            //Match three cards
                                            let match3CardsScore = card.match([otherCard, otherCard2])
                                            //if all three match either rank or suit then add points, else loose points
                                            if match3CardsScore > 0 {
                                                otherCard.playable = false
                                                card.playable = false
                                                otherCard2.playable = false
                                                score += match3CardsScore + CardMatchingGame.MATCH_BONUS
                                                if !flipResultsStringPosted {
                                                    flipResults = "Matched \(card.contents) & \(otherCard.contents) & \(otherCard2.contents): \(match3CardsScore + CardMatchingGame.MATCH_BONUS - 1) points"
                                                    flipResultsStringPosted = true
                                                }
                                                
                                            } else {
                                                //three cards didn't match
                                                score -= CardMatchingGame.MISMATCH_PENALTY
                                                if !flipResultsStringPosted {
                                                    flipResults = "\(card.contents) & \(otherCard.contents) & \(otherCard2.contents) don't match: \(-CardMatchingGame.MISMATCH_PENALTY - 1) points"
                                                    flipResultsStringPosted = true
                                                }
                                            }
                                            break
                                        } else if cardsPlayableAndFacedUp > 1 {
                                            //first two cards didn't match and three cards aren't on the table
                                            score -= CardMatchingGame.MISMATCH_PENALTY
                                            if !flipResultsStringPosted {
                                                flipResults = "\(card.contents) & \(otherCard.contents) & \(otherCard2.contents) don't match: \(-CardMatchingGame.MISMATCH_PENALTY - 1) points"
                                                flipResultsStringPosted = true
                                            }
                                            break
                                        }
                                    }
                                }
                                break
                            }
                        }//if only flip occurs
                        score -= CardMatchingGame.FLIP_COST
                        if !flipResultsStringPosted {
                            flipResults = "Flipped up \(card.contents): normal -\(CardMatchingGame.FLIP_COST) flip cost"
                        }
                        flipResultsStringPosted = false
                    } else {
                        //if there are already three cards on the table it prevents you from flipping again
                        flipResults = "Too many cards flipped over!"
                        card.faceUp = !card.faceUp
                    }
                }
                card.faceUp = !card.faceUp
            }
        }
    }
    
    func flipResultsString () -> String {
        return flipResults
    }
    
    func currentScore() -> Int {
        return score
    }
}