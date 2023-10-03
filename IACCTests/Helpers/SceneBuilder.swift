import UIKit
@testable import IACC

struct SceneBuilder {
    static func reset() {
        User.shared = nil
        
        FriendsAPI.shared = FriendsAPI()
        SceneDelegate.main.cache = FriendsCache()
        
    }
    
    func build(
        user: User? = nil,
        friendsAPI: FriendsAPI = .once([]),
        friendsCache: FriendsCache = .never,
        cardsAPI: CardAPI = .once([])
    )  throws -> ContainerViewControllerSpy {
        SceneDelegate.main.window?.rootViewController = nil
        SceneDelegate.main.cache = friendsCache
        
        User.shared = user
        FriendsAPI.shared = friendsAPI
        CardAPI.shared = cardsAPI
        
        return ContainerViewControllerSpy(SceneDelegate.main.makeRootViewController())
    }
}


private extension SceneDelegate {
    static var main: SceneDelegate {
        (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate)
    }
}
