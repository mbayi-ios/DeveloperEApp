//
//  Card+TestHelpers.swift
//  IACCTests
//
//  Created by Ambrose Mbayi on 03/10/2023.
//

import Foundation
@testable import IACC

func aCard(id: Int = Int.random(in: 1...Int.max), number: String = "any number", holder: String = "any holder") -> Card {
    Card(id: id, number: number, holder: holder)
}
