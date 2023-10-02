//
//  Friend+TestHelpers.swift
//  IACCTests
//
//  Created by Ambrose Mbayi on 02/10/2023.
//

import Foundation
@testable import IACC
/// this test helper method provides a way of creating `Friend` models without coupling the
/// test with the `Friend` initializer. This way we can change the `Friend` dependancies
/// and initializer without breaking tests(we just need to update the helper method).

func aFriend(id: UUID = UUID(), name: String = "any name", phone: String = "any phone") -> Friend {
    Friend(id: id, name: name, phone: phone)
}
