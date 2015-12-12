//
//  gameResult.swift
//  Matchismo
//
//  Created by Michael Perry on 10/4/15.
//  Copyright © 2015 Michael Perry. All rights reserved.
//

import Foundation

class GameResult {

    internal var score = 0
    internal var whenScoreLastUpdated = NSDate()
    internal var whenGameStarted = NSDate()
    internal var duration: Double = 0.0
    
    internal static func getGameResultsHistory () -> [GameResult] {
        
        if let gameResultsObject = NSUserDefaults.standardUserDefaults().objectForKey("gameResults") as? Array<String> {
            let formattedGameResultsArray = GameResult.propertyListToArrayOfGameResults(gameResultsObject)
            return formattedGameResultsArray
        } else {
            NSUserDefaults.standardUserDefaults().setObject(Array<String>(), forKey: "gameResults")
            NSUserDefaults.standardUserDefaults().synchronize()
            return NSUserDefaults.standardUserDefaults().objectForKey("gameResults") as! [GameResult]
        }
    }
    
    //add game result history differs from update (listed lower on page) in that 
    //it appends a new string to the stack without remove the top from the stack
    internal static func addGameResultsHistory (gameResult: GameResult) {

        let gameResultString = GameResult.gameResultToString(gameResult)
        
        if var gameResultsObject = NSUserDefaults.standardUserDefaults().objectForKey("gameResults") as? Array<String> {
            gameResultsObject.append(gameResultString)
            NSUserDefaults.standardUserDefaults().setObject(gameResultsObject, forKey: "gameResults")
            NSUserDefaults.standardUserDefaults().synchronize()
        } else {
            NSUserDefaults.standardUserDefaults().setObject([gameResultString], forKey: "gameResults")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    //remove top string from propertylist string array and add new string with current GameResult object values
    internal static func updateGameResultsHistory (gameResult: GameResult) {
        var gameResultsObject = NSUserDefaults.standardUserDefaults().objectForKey("gameResults") as! Array<String>
        if gameResultsObject.count > 0 {
            let gameResultString = GameResult.gameResultToString(gameResult)
            
            gameResultsObject.removeLast()
            
            gameResultsObject.append(gameResultString)
            NSUserDefaults.standardUserDefaults().setObject(gameResultsObject, forKey: "gameResults")
            NSUserDefaults.standardUserDefaults().synchronize()
        } else {
            let gameResultString = GameResult.gameResultToString(gameResult)
            gameResultsObject.append(gameResultString)
            
            NSUserDefaults.standardUserDefaults().setObject(gameResultsObject, forKey: "gameResults")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    //load array of of GameResult objects from string array propertylist
    internal static func propertyListToArrayOfGameResults (arrayFromPropertyList: [String]) -> [GameResult] {
        var gameResults = [GameResult]()
        
        let dateFormatter = NSDateFormatter()
        
        var tempWhenGameStarted = ""
        var tempWhenScoreLastUpdated = ""
        
        for gameResult in arrayFromPropertyList {
            let gameResultObject = GameResult()
            let parts = gameResult.componentsSeparatedByString(" ")
            
            gameResultObject.score = Int(parts[0])!
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            
            tempWhenGameStarted = "\(parts[1]) \(parts[2]) \(parts[3])"
            tempWhenScoreLastUpdated = "\(parts[4]) \(parts[5]) \(parts[6])"
            
            gameResultObject.whenGameStarted = dateFormatter.dateFromString(tempWhenGameStarted)!
            gameResultObject.whenScoreLastUpdated = dateFormatter.dateFromString(tempWhenScoreLastUpdated)!
            gameResultObject.duration = -(round(gameResultObject.whenGameStarted.timeIntervalSinceDate(gameResultObject.whenScoreLastUpdated)*10)/10)
            
            gameResults.append(gameResultObject)
        }
        return gameResults
    }
    
    //format GameResult object to desired looking string
    internal static func formatGameResultObjectAsString (gameResult: GameResult) -> String {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/YY";
        let startGameDate = formatter.stringFromDate(gameResult.whenGameStarted)
        formatter.timeStyle = .ShortStyle
        let startGameTime = formatter.stringFromDate(gameResult.whenGameStarted)
        let duration = -(round(gameResult.whenGameStarted.timeIntervalSinceDate(gameResult.whenScoreLastUpdated)*10)/10)

        let formattedGameResult = "Score: \(gameResult.score) (\(startGameDate), \(startGameTime), \(duration)s)"
            
        return formattedGameResult
    }
    
    //convert GameResult object to string for storage
    internal static func gameResultToString (gameResult: GameResult) -> String {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        formatter.timeZone = NSTimeZone(name: "UTC")
        
        let timeStamp = formatter.stringFromDate(gameResult.whenGameStarted)
        let timeStamp2 = formatter.stringFromDate(gameResult.whenScoreLastUpdated)
        
        return "\(gameResult.score) \(timeStamp) \(timeStamp2)"
    }
    

}