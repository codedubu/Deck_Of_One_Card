//
//  CardController.swift
//  DeckOfOneCard
//
//  Created by River McCaine on 1/26/21.
//  Copyright © 2021 Warren. All rights reserved.
//

import UIKit

// Endpoint
// https://deckofcardsapi.com/api/deck/new/draw/{?count=1} ?

class CardController {
    
    static var baseURL = URL(string: "https://deckofcardsapi.com/api/deck/new/draw")
    static let newEndpoint = "new"
    static let drawEndpoint = "draw"
    
    static func fetchCard(completion: @escaping (Result<Card, CardError>) -> Void) {
        // step 1: Prepare URL
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        // https://deckofcardsapi.com/api/deck/new/draw}
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let countQuery = URLQueryItem(name: "count", value: "1")
        components?.queryItems = [countQuery]
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        // step 2: Contact errors from server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            // step 3: Handle errors from the server
            if let error = error {
                print("========= ERROR =========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("========= ERROR =========")
                
                return completion(.failure(.thrownError(error)))
            }
            // step 4: Check for JSON data
            guard let data = data else { return completion(.failure(.noData)) }
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                
                guard let cards = topLevelObject.cards else { return completion(.failure(.noData)) }
                let firstCard = cards[0]
                // step 5: Decode JSON into a Card
                return completion(.success(firstCard))
                
            } catch let decodeError {
                print("========= ERROR =========")
                print("Function: \(#function)")
                print("Error: \(decodeError)")
                print("Description: \(decodeError.localizedDescription)")
                print("========= ERROR =========")
                return completion(.failure(.thrownError(decodeError)))
            }
        }.resume()
    }
    
    static func fetchImage(for card: Card, completion: @escaping(Result<UIImage, CardError>) -> Void) {
        // step 1: Prepare URL
        let imageURL = card.image
        // step 2: Contact server
        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            // step 3: Handle errors from the server
            if let error = error {
                print("========= ERROR =========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("========= ERROR =========")
                
                return completion(.failure(.thrownError(error)))
            }
            // step 4: Check for image data
            guard let data = data else { return completion(.failure(.noData)) }
            guard let cardImage = UIImage(data: data) else { return completion(.failure(.unableToDecode)) }
            
            // step 5: Initialize an image from the data
            completion(.success(cardImage))
        }.resume()
    }
} // END OF CLASS
