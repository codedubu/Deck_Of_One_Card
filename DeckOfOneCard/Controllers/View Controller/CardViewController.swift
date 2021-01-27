//
//  CardViewController.swift
//  DeckOfOneCard
//
//  Created by River McCaine on 1/26/21.
//  Copyright © 2021 Warren. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var cardValueAndSuiteLabel: UILabel!
    @IBOutlet weak var cardImageImageView: UIImageView!
    @IBOutlet weak var drawButton: UIButton!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    @IBAction func drawButtonTapped(_ sender: Any) {
        CardController.fetchCard { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let card):
                    self?.fetchImageAndUpdateViews(for: card)
                case .failure(let error):
                    self?.presentErrorToUser(localizedError: error)
                }
            }
        }
        
        if drawButton.titleLabel?.text == "♦️♣️ Draw! ♥️♠️" {
            drawButton.setTitle("♠️♦️ Draw! ♣️♥️", for: .normal)
        } else if drawButton.titleLabel?.text == "♠️♦️ Draw! ♣️♥️" {
            drawButton.setTitle("♦️♣️ Draw! ♥️♠️", for: .normal)
        }
    }
    
    // MARK: - Helper Functions
    func fetchImageAndUpdateViews(for card: Card) {
        // (Result<UIImage,CardError>) = result
        CardController.fetchImage(for: card) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let cardImage):
                    self?.cardImageImageView.image = cardImage
                    self?.cardValueAndSuiteLabel.text = "\(card.value) of \(card.suit)"
                case .failure(let error):
                    self?.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
} // END OF CLASS
