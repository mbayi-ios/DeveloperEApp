
import UIKit
import XCTest
@testable import IACC

class ContainerViewControllerSpy: UIViewController {
    private(set) static var current = ContainerViewControllerSpy()
    
    private var rootTabBar: UITabBarController?
    
    convenience init(_ rootViewController: UITabBarController) {
        self.init()
        
        ContainerViewControllerSpy.current = self
        
        rootTabBar = rootViewController
        addChild(rootViewController)
        rootViewController.view.frame = view.frame
        view.addSubview(rootViewController.view)
        rootViewController.didMove(toParent: self)
    }
    
    func rootTab<T>(atIndex index: Int) throws -> T {
        let root = try XCTUnwrap(rootTabBar, "root tab bar not set")
        
        if root.selectedIndex != index {
            root.selectedIndex = index
        }
        
        return try XCTUnwrap(root.selectedViewController as? T, "controller type at tab \(index) should be \(String(describing: T.self))")
    }
}
