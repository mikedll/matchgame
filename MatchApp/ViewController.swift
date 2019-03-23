//
//  ViewController.swift
//  MatchApp
//
//  Created by Michael Rivera on 3/19/19.
//  Copyright © 2019 Michael Rivera. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var model = CardModel()
    var cardArray = [Card]()
    
    var timer:Timer?
    var milliseconds:Float = 30 * 1000 // 10 Seconds
    
    var firstFlippedCardIndex:IndexPath?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // call getCards method of the card model
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        // Create timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.playSound(.shuffle)
    }

    // MARK: - Time Methods
    
    @objc func timerElapsed() {
        milliseconds -= 1
        
        // Convert to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        timerLabel.text = "Time Remaining: \(seconds)"
        
        // When timer has reached zero...
        if milliseconds <= 0 {
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            // Check if there are any cards unmatched
            checkGameEnded()
        }
    }
    
    // MARK: - UICollectionView Protocol Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get a CardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Get the card that the CollectionView is trying to display
        let card = cardArray[indexPath.row]
        
        // Set that card for the cell
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if milliseconds <= 0 {
            return
        }
        
        // Get cell that user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // Get card that user selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false {
            // Flip the card
            cell.flip()
            
            // Play the flip sound
            SoundManager.playSound(.flip)
            
            // Set status of card
            card.isFlipped = true
            
            // Determine if it's the first card or second card that's flipped over
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            }
            else {
                // This is the second card being flipped
                
                // Perform the matching logic
                checkForMatches(indexPath)
            }
        }
        else {
            // Flip the card back
            cell.flipBack()
            
            // Set status of card
            card.isFlipped = false
        }
    } // end didSelectItemAt method
    
    // MARK: Game Logic Methods
    func checkForMatches(_ secondFlippedCardIndex:IndexPath) {
        // Get the cells for the two cards that were revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        
        // Get the cards for the two cards that were revealed
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        // Compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            // It's a match
            
            // Play Sound
            SoundManager.playSound(.match)
            
            // Set the statuses of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // Remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Check if there are any cards left unmatched
            checkGameEnded()
        }
        else {
            // It's not a match
            SoundManager.playSound(.nomatch)
            
            // Set the statuses of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip both cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        // Tell the collectionView to reload the cell of the first card
        // if it is nil.
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        // Reset the property that tracks the first card flipped
        firstFlippedCardIndex = nil
    }

    func checkGameEnded() {
        // Determine if there are any cards unmatched
        var isWon = true
        
        for card in cardArray {
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        // Messaging variables
        var title = ""
        var message = ""
        
        // If not, user has won. Stop the timer.
        if isWon == true {
            if milliseconds > 0 {
                timer?.invalidate()
                
            }
            
            title = "Congratualations!"
            message = "You've won"
        }
        else {
            // If there are unmatched cards, check if there's any time
            // left
            if milliseconds > 0 {
                return
            }
            title = "Game Over"
            message = "You've lost"
        }
        
        // Show won/lost messaging
        showAlert(title, message)
    }
    
    func showAlert(_ title:String, _ message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
} // End ViewControllerclass

