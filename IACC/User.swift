//
//  User.swift
//  IACC
//
//  Created by Ambrose Mbayi on 02/10/2023.
//

import Foundation
struct User {
    static var shared: User?
    
    let id: UUID
    let name: String
    let isPremium: Bool
}
