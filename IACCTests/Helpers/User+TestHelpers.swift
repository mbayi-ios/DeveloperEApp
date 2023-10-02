import Foundation
@testable import IACC

func nonPremiumUser() -> User {
    aUser(isPremium: false)
}

func premiumUser() -> User {
    aUser(isPremium: true)
}


func aUser(id: UUID = UUID(), name: String = "any name", isPremium: Bool) -> User {
    User(id: id, name: name, isPremium: isPremium)
}
