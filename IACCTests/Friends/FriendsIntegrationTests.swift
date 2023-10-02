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
    
    func test_friendsList_hasAddFriendButton() throws {
        let friendsList = try SceneBuilder().build().friendsList()
        
        XCTAssertTrue(friendsList.hasAddFriendButton, "add friend button not found")
    }
    
    func test_friendsList_addFriendButton_showsAddFriendViewOnTap() throws {
        let friendsList = try SceneBuilder().build().friendsList()
        
        XCTAssertFalse(friendsList.isPresentingAddFriendView, "precondition: shouldn't present add friend view before tapping button")
    }
    
    func test_friendsList_withNonPremiumUser_showsFriends_whenAPIRequestSucceeds() throws {
        let friend0 = aFriend(name: "a name", phone: "a phone")
        let friend1 = aFriend(name: "another name", phone: "another phone")
        let friendsList = try SceneBuilder()
            .build(
                user: nonPremiumUser(),
                friendsAPI: .once([friend0, friend1]),
                friendsCache: .never
            )
            .friendsList()
        
        XCTAssertEqual(friendsList.numberOfFriends(), 2, "friends count")
        XCTAssertEqual(friendsList.friendName(at: 0), friend0.name, "friend name at row 0")
        XCTAssertEqual(friendsList.friendPhone(at: 0), friend0.phone, "friend phone at row 0")
        XCTAssertEqual(friendsList.friendName(at: 1), friend1.name, "friend name at row 1")
        XCTAssertEqual(friendsList.friendPhone(at: 1), friend1.phone, "friend phone at row 1")
    }
    
    func test_friendsList_showsLoadingIndicator_untilAPIRequestSucceeds() throws  {
        let friendsList = try SceneBuilder()
            .build(
                friendsAPI: .resultBuilder {
                    let friendsList = try? ContainerViewControllerSpy.current.friendsList()
                    XCTAssertEqual(friendsList?.isShowingLoadingIndicator(), true, "should show loading indicator unitl API request completes")
                    return .success([aFriend()])
                },
                friendsCache: .never
            )
            .friendsList()
        
        XCTAssertEqual(friendsList.isShowingLoadingIndicator(), false, "should hide loading indicator once API request completes")
        
        friendsList.simulateRefresh()
        
        XCTAssertEqual(friendsList.isShowingLoadingIndicator(), false, "should hide loading indicator once API refesh request completes")
    }
    
    func test_friendsList_withNonPremiumUser_showsLoadingIndicator_whileRetryingAPIRequests() throws {
        let friendsList = try SceneBuilder()
            .build(
                user: nonPremiumUser(),
                friendsAPI: .resultBuilder {
                    let friendsList = try? ContainerViewControllerSpy.current.friendsList()
                    XCTAssertEqual(friendsList?.isShowingLoadingIndicator(), true, "should show loading indicator while retrying API requests")
                    return .failure(anError())
                },
                friendsCache: .never
            )
            .friendsList()
        
        XCTAssertEqual(friendsList.isShowingLoadingIndicator(), false, "should hid loading indicator after retrying API requests")
        
        friendsList.simulateRefresh()
        
        XCTAssertEqual(friendsList.isShowingLoadingIndicator(), false, "should hid loading indicator afrer retrying API Refresh request")
    }
    
}


private extension ContainerViewControllerSpy {
    func friendsList() throws -> ListViewController {
        let vc = try XCTUnwrap((rootTab(atIndex: 0) as UINavigationController).topViewController as? ListViewController, "couldnt find friends list")
        vc.prepareForFirstAppearance()
        return vc
    }
}

private extension ListViewController {
    func numberOfFriends() -> Int {
        numberOfRows(atSection: friendsSection)
    }
    
    func friendName(at row: Int) -> String? {
        title(at: IndexPath(row: row, section: friendsSection))
    }
    
    func friendPhone(at row: Int) -> String? {
        subtitle(at: IndexPath(row: row, section: friendsSection))
    }
    
    var hasAddFriendButton: Bool {
        navigationItem.rightBarButtonItem?.systemItem == .add
    }
    
    var isPresentingAddFriendView: Bool {
        navigationController?.topViewController is AddFriendViewController
    }
    
    private var friendsSection: Int { 0 }
}
