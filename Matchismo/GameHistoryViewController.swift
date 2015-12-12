//
//  GameHistoryViewController.swift
//  Matchismo
//
//  Created by Michael Perry on 10/4/15.
//  Copyright © 2015 Michael Perry. All rights reserved.
//

import UIKit

class GameHistoryViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var sgmtctrlSortBy: UISegmentedControl!
    
    @IBAction func sgmtctrlSortBy(sender: AnyObject) {
        pastGameResults = GameResult.getGameResultsHistory()
        self.tblView.reloadData()
    }
    
    var pastGameResults: [GameResult] = GameResult.getGameResultsHistory()
    internal static var highScore: Int = 0
    internal static var lowScore: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        pastGameResults = GameResult.getGameResultsHistory()
        self.tblView.reloadData()
        if pastGameResults.count > 0 {
            grabHighestAndLowestScore()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func grabHighestAndLowestScore () {
        var tempPastGameResults = GameResult.getGameResultsHistory()
        
        tempPastGameResults = tempPastGameResults.sort({ $0.score > $1.score })
        
        GameHistoryViewController.highScore = tempPastGameResults.first!.score
        GameHistoryViewController.lowScore = tempPastGameResults.last!.score
    }

}

extension GameHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return pastGameResults.count
        }
    }
    
    internal static func addLabelAtrributes(label: String) -> NSMutableAttributedString {
        let parts = label.componentsSeparatedByString(" ")
        
        let attributedLabel = NSMutableAttributedString(string: label)
        let myRange = NSRange(location: 7, length: parts[1].characters.count)
        
        if Int(parts[1]) == highScore {
            attributedLabel.addAttribute(NSForegroundColorAttributeName, value: UIColor.yellowColor(), range: myRange)
            attributedLabel.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(17.0, weight: 1), range: myRange)
        } else if Int(parts[1]) == lowScore {
            attributedLabel.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: myRange)
            attributedLabel.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(17.0, weight: 1), range: myRange)
        } else {
            attributedLabel.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 0.88, green: 0.48, blue: 0.1, alpha: 1), range: myRange)
            attributedLabel.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(17.0, weight: 0.3), range: myRange)
        }
        
        return attributedLabel
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tblView.dequeueReusableCellWithIdentifier("HeaderCell", forIndexPath: indexPath) as! HistoryTableViewHeaderCellTableViewCell
            return cell
        } else {
            let cell = tblView.dequeueReusableCellWithIdentifier("GameResultsCell", forIndexPath: indexPath) as! HistoryTableViewGameResultsCell
            
            let row = indexPath.row
            let count = pastGameResults.count
            
            var gameResultString: String
            
            if sgmtctrlSortBy.titleForSegmentAtIndex(sgmtctrlSortBy.selectedSegmentIndex)! == "Score" {
                pastGameResults = pastGameResults.sort({ $0.score > $1.score })
                gameResultString = GameResult.formatGameResultObjectAsString(pastGameResults[row])
            } else if sgmtctrlSortBy.titleForSegmentAtIndex(sgmtctrlSortBy.selectedSegmentIndex)! == "Date" {
                gameResultString = GameResult.formatGameResultObjectAsString(pastGameResults[count-row-1])
            } else {
                pastGameResults = pastGameResults.sort({ $0.duration < $1.duration })
                gameResultString = GameResult.formatGameResultObjectAsString(pastGameResults[row])
            }
            
            let attributedText = GameHistoryViewController.addLabelAtrributes(gameResultString)
            cell.lblGameScore.attributedText = attributedText
            
            return cell
        }
    }
    
}