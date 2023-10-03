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
}


private extension ContainerViewControllerSpy {
    func cardsList() throws -> ListViewController {
        let vc = try XCTUnwrap((rootTab(atIndex: 2) as UINavigationController).topViewController as? ListViewController, "couldnt find card list")
        vc.prepareForFirstAppearance()
        return vc
    }
}


private extension ListViewController {
    var hasAddCardButton: Bool {
        navigationItem.rightBarButtonItem?.systemItem == .add
    }
    
    var isPresentingAddCardView: Bool {
        navigationController?.topViewController is AddCardViewController
    }
}
