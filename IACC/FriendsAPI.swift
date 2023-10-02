//
//  FriendsAPI.swift
//  IACC
//
//  Created by Ambrose Mbayi on 02/10/2023.
//

import Foundation

struct Friend: Equatable {
    let id: UUID
    let name: String
    let phone: String
}


class FriendsAPI {
    static var shared = FriendsAPI()
    
    /// for demo purposes this method simulates an API request with a pre-defined response and delay
    func loadFriends(completion: @escaping (Result<[Friend], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.75) {
            completion(.success([
            Friend(id: UUID(), name: "amby", phone: "254716402736"),
            Friend(id: UUID(), name: "ben", phone: "254716402525")
            ]))
        }
    }
}
