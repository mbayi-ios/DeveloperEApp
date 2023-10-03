//
//  CardAPI.swift
//  IACC
//
//  Created by Ambrose Mbayi on 03/10/2023.
//

import Foundation

struct Card: Equatable {
    let id: Int
    let number: String
    let holder: String
}

class CardAPI {
    static var shared = CardAPI()
    
    /// for demo purposes this method simulates an API request with a pre-defined response and delay
    ///
    func loadCards(completion: @escaping(Result<[Card], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            completion(.success([
                Card(id: 1, number: "*****-0883", holder: "J. Doe"),
                Card(id: 2, number: "*****-8329", holder: "Doe J")
            ]))
        }
    }
}
