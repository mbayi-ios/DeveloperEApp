import Foundation
@testable import IACC

/// The `FriendsAPI` test helper extension provides fast and reliable way to stubbing
/// network requests with canned results to prevent making real netwrk requests during tests
///
extension FriendsAPI {
    static var never: FriendsAPI {
        results([])
    }
    
    static func once(_ friends: [Friend]) -> FriendsAPI {
        results([.success(friends)])
    }
    
    static func results(_ results: [Result<[Friend], Error>]) -> FriendsAPI {
        var results = results
        return resultBuilder { results.removeFirst()}
    }
    
    static func resultBuilder(_ resultBuilder: @escaping () -> Result<[Friend], Error>) -> FriendsAPI {
        FriendsAPIStub(resultBuilder: resultBuilder)
    }
    
    private class FriendsAPIStub: FriendsAPI {
        private let nextResult: () -> Result<[Friend], Error>
        
        init(resultBuilder: @escaping ()-> Result<[Friend], Error>) {
            nextResult = resultBuilder
        }
        
        override func loadFriends(completion: @escaping (Result<[Friend], Error>) -> Void) {
            completion(nextResult())
        }
    }
}
