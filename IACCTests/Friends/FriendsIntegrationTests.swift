import XCTest
@testable import IACC

/// when dealing with legacy code, you most likely wont be able to test screens independently
/// because all dependencies are accessed directly through singletons or passed from one view controller to another
///
/// so the simplest way to start testing legacy code is to write intergration tests covering the behavior from the view controllers all the way to deeper dependencies such as database and network classes
///
///
/// writing fast and realiable integration tests before making changes to a legacy codebazse can give you confidence
/// that you dont break existing behavior. If you trust those tests and they still pass after a change, you're sure you dint
/// break anything
///
/// That is why it is important to write tests you trust before making a change in legacy code
///
/// So good Integration Tests can give you the confidence you didnt break anything when they pass
/// But when they fail, it can be hard to find out why it failed and where is the problem because many components
/// are being tested together. The problem could be in a view, or i a model or in the database, or in the network
/// component. You probably will have to debug to find the issue
///
/// Thus Integration Tests shouldnt be your primary testing stragegy. Instead you should focus on testing components
/// in isolation. So if the tests fail,you know exactly why and where
///
/// But integration Tests can be a simple way to start adding coverage to a legacy project until you can break down the
/// components and test them in isolation
///
/// So to make this legacy project realistic, we kept the entangled legacy calsses to show how you can start testing
/// components in intergration without making massive changes to the project
///


class FriendsIntegrationTests: XCTestCase {
    override func tearDown() {
        SceneBuilder.reset()
        
        super.tearDown()
    }
    
    func test_friendsList_title() throws {
        let friendsList = try SceneBuilder().build().friendsList()
        
        XCTAssertEqual(friendsList.title, "Friends")
    }
}


private extension ContainerViewControllerSpy {
    func friendsList() throws -> ListViewController {
        let vc = try XCTUnwrap((rootTab(atIndex: 0) as UINavigationController).topViewController as? ListViewController, "couldnt find friends list")
        vc.prepareForFirstAppearance()
        return vc
    }
}
