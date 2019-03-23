//
//  CardModel.swift
//  MatchApp
//
//  Created by Michael Rivera on 3/19/19.
//  Copyright © 2019 Michael Rivera. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        // Declare array to store numbers we've already generated.
        var generatedNumbersArray = [Int]()
        
        // Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        
        // Randomly generate pairs of cards
        while generatedNumbersArray.count < 8 {
            let randomNumber = arc4random_uniform(13) + 1
            
            // Ensure that the random number isn't one that we already have
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                // Log the number
                print("generating a random number \(randomNumber)")
                
                // Store the number into the generated numbers array
                generatedNumbersArray.append(Int(randomNumber))
                
                // Create first card object
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardOne)
                
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardTwo)
            }
        }
        
        // Randomize the array
        for i in 0...generatedCardsArray.count-1 {
            // Find a random index to swap with
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
            
            // Swap the two cards
            let temporaryStorage = generatedCardsArray[i]
            generatedCardsArray[i] = generatedCardsArray[randomNumber]
            generatedCardsArray[randomNumber] = temporaryStorage
        }
        
        // Return the array
        return generatedCardsArray
    }
}
