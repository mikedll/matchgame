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
        
        // Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        
        // Randomly generate pairs of cards
        for _ in 1...8 {
            let randomNumber = arc4random_uniform(13) + 1
            
            // Log the number
            print("generating a random number \(randomNumber)")
            
            // Create first card object
            let cardOne = Card()
            cardOne.imageName = "card\(randomNumber)"
            generatedCardsArray.append(cardOne)
            
            let cardTwo = Card()
            cardTwo.imageName = "card\(randomNumber)"
            generatedCardsArray.append(cardTwo)
            
            // Optional: Make it so we only have unique pairs of cards.
        }
        
        print(generatedCardsArray.count)
        // TODO: Randomize the array
        
        // Return the array
        return generatedCardsArray
    }
}
