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
}


private extension ContainerViewControllerSpy {
    func cardsList() throws -> ListViewController {
        let vc = try XCTUnwrap((rootTab(atIndex: 2) as UINavigationController).topViewController as? ListViewController, "couldnt find card list")
        vc.prepareForFirstAppearance()
        return vc
    }
}
