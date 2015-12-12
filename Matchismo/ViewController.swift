//
//  ViewController.swift
//  Matchismo
//
//  Created by Michael Perry on 9/25/15.
//  Copyright © 2015 Michael Perry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var game: CardMatchingGame!
    private var gameResult: GameResult!
    internal static var firstFlip: Bool = true
    
    var flipCount: Int = 0 {
        didSet {
            lblFlips.text = "Flips: \(flipCount)"
        }
    }
    
    var score: Int = 0 {
        didSet {
            lblScore.text = "Score: \(score)"
            gameResult.score = score
        }
    }
    
    var flipResultString: String = "" {
        didSet {
            lblLastFlip.text = flipResultString
        }
    }

    //indicator of game setting (whether it is matching 3 cards or 2)
    var cardMatchGameSetting: String = "2 Card"
    
    
    var segmentControlActive: Bool = true {
        didSet {
            sgmtctrl2or3Cards.enabled = segmentControlActive
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameResult = GameResult()
    }
    
    @IBOutlet weak var lblFlips: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblLastFlip: UILabel!
    
    @IBOutlet weak var sgmtctrl2or3Cards: UISegmentedControl!
    
    @IBAction func sgmtctrl2or3CardClick(sender: AnyObject) {
        cardMatchGameSetting = sgmtctrl2or3Cards.titleForSegmentAtIndex(sgmtctrl2or3Cards.selectedSegmentIndex)!
    }
    
    @IBOutlet var cardButtons: [UIButton]!{
        didSet {
            game = CardMatchingGame(cardCount: cardButtons.count, deck: PlayingCardDeck())
        }
    }
    
    @IBAction func btnFlipCard(sender: UIButton) {
        if cardMatchGameSetting == "2 Card" {
            game.flipCardAtIndex(indexOfButton(sender))
        } else {
            game.flipCardAtIndexThreeCards(indexOfButton(sender))
        }
        if let card = game.cardAtIndex(indexOfButton(sender)) {
            if card.faceUp {
                ++flipCount
            }
        }
        segmentControlActive = false
        updateUI()
        
        if ViewController.firstFlip {
            GameResult.addGameResultsHistory(gameResult)
            gameResult.whenGameStarted = NSDate()
            ViewController.firstFlip = false
        }
        gameResult.whenScoreLastUpdated = NSDate()
        GameResult.updateGameResultsHistory(gameResult)
        
    }
    
    @IBAction func btnRedeal(sender: AnyObject) {
        
        game = CardMatchingGame(cardCount: cardButtons.count, deck: PlayingCardDeck())
        gameResult = GameResult()
        
        score = game.currentScore()
        flipResultString = game.flipResultsString()
        flipCount = 0
        updateUI()
        for button in cardButtons {
            let card = game.cardAtIndex(indexOfButton(button))!
            button.enabled = card.playable
        }
        segmentControlActive = true
        ViewController.firstFlip = true
    }
    
    private func indexOfButton(button: UIButton) -> Int {
        for i in 0 ..< cardButtons.count {
            if button == cardButtons[i] {
                return i
            }
        }
        return -1
    }
    
    private func updateUI() {
        let cardBack = UIImage(named: "CardBack")
        let cardFront = UIImage(named: "CardFront")
        
        for button in cardButtons {
            let card = game.cardAtIndex(indexOfButton(button))!
            
            if card.faceUp {
                button.setTitle(card.contents, forState: .Normal)
                button.setBackgroundImage(cardFront, forState: .Normal)
                button.enabled = card.playable
            } else {
                button.setTitle("", forState: .Normal)
                button.setBackgroundImage(cardBack, forState: .Normal)
            }
        }
        score = game.currentScore()
        flipResultString = game.flipResultsString()
    }
}

