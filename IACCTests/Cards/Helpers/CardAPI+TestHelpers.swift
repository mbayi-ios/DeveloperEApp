//
//  CardAPI+TestHelpers.swift
//  IACCTests
//
//  Created by Ambrose Mbayi on 03/10/2023.
//

import Foundation
@testable import IACC

extension CardAPI {
    static func once(_ cards: [Card]) -> CardAPI
    {
        results([.success(cards)])
    }
    
    static func results(_ results: [Result<[Card], Error>]) -> CardAPI {
        var results = results
        return resultBuilder {
            results.removeFirst()
        }
    }
    
    static func resultBuilder(_ resultBuilder: @escaping () -> Result<[Card], Error>) -> CardAPI {
        CardAPIStub(resultBuilder: resultBuilder)
    }
    
    private class CardAPIStub: CardAPI {
        private let nextResult: () -> Result<[Card], Error>
        
        init(resultBuilder: @escaping () -> Result<[Card], Error>) {
            nextResult = resultBuilder
        }
        
        override func loadCards(completion: @escaping (Result<[Card], Error>) -> Void) {
            completion(nextResult())
        }
    }
}
