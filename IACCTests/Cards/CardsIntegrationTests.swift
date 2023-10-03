//
//  CardsIntegrationTests.swift
//  IACCTests
//
//  Created by Ambrose Mbayi on 03/10/2023.
//

import XCTest
@testable import IACC

class CardsIntegrationTest: XCTestCase {
    override func tearDown() {
        SceneBuilder.reset()
        
        super.tearDown()
    }
    
    func test_cardsList_title()  throws {
        let cardsList = try SceneBuilder().build().cardsList()
        
        XCTAssertEqual(cardsList.title, "Cards", "title")
    }
    
    func test_cardsList_hasAddCardButton() throws {
        let cardsList = try SceneBuilder().build().cardsList()
        
        XCTAssertTrue(cardsList.hasAddCardButton, "add card button not found")
    }
    
    func test_cardsList_addCardButton_showsAddCardViewOnTap() throws {
        let cardsList = try SceneBuilder().build().cardsList()
        
        XCTAssertFalse(cardsList.isPresentingAddCardView, "precondigion: shouldn't present add card view before tapping button")
    }
    
    func test_cardsList_showsCards_whenAPIRequestSucceeds() throws {
        let card0 = aCard(number: "a number", holder: "a holder")
        let card1 = aCard(number: "another number", holder: "another holder")
        let cardsList = try SceneBuilder()
            .build(cardsAPI: .once([card0, card1]))
            .cardsList()
        
        XCTAssertEqual(cardsList.numberOfCards(), 2, "cards count")
        XCTAssertEqual(cardsList.cardNumber(at: 0), card0.number, "card number at row 0")
        XCTAssertEqual(cardsList.cardHolder(at: 0), card0.holder, "card holder at row 0")
        XCTAssertEqual(cardsList.cardNumber(at: 1), card1.number, "card number at row 1")
        XCTAssertEqual(cardsList.cardHolder(at: 1), card1.holder, "card holder at row 1")
        
    }
}


private extension ContainerViewControllerSpy {
    func cardsList() throws -> ListViewController {
        let vc = try XCTUnwrap((rootTab(atIndex: 2) as UINavigationController).topViewController as? ListViewController, "couldnt find card list")
        vc.prepareForFirstAppearance()
        return vc
    }
}


private extension ListViewController {
    func numberOfCards() -> Int {
        numberOfRows(atSection: cardsSection)
    }
    
    func cardNumber(at row: Int) -> String? {
        title(at: IndexPath(row: row, section: cardsSection))
    }
    
    func cardHolder(at row: Int) -> String? {
        subtitle(at: IndexPath(row: row, section: cardsSection))
    }
    
    var hasAddCardButton: Bool {
        navigationItem.rightBarButtonItem?.systemItem == .add
    }
    
    var isPresentingAddCardView: Bool {
        navigationController?.topViewController is AddCardViewController
    }
    
    private var cardsSection: Int { 0 }
}
