//
//  FriendsCache.swift
//  IACC
//
//  Created by Ambrose Mbayi on 02/10/2023.
//

import Foundation

class FriendsCache {
    private var friends: [Friend]?
    
    private struct NoFriendsFound: Error {}
    
    /// For demo purposes, this method simulates a database lookup with a pre-defined in-memory response and delay
    func loadFriends(completion: @escaping(Result<[Friend], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.25) {
            if let friends = self.friends {
                completion(.success(friends))
            } else {
                completion(.failure(NoFriendsFound()))
            }
        }
    }
    
    /// for demo purposes, this method simulates a cache with an in-memory referecne to the provided friends
    func save(_ newFriends: [Friend]) {
        friends = newFriends
    }
}
