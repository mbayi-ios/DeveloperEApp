import UIKit
@testable import IACC

extension ListViewController {
    func prepareForFirstAppearance() {
        guard !isViewLoaded else { return }
        
        loadViewIfNeeded()
        replaceRefreshControlWithSpy()
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
    
    private func replaceRefreshControlWithSpy() {
        let currentRefreshControl = refreshControl
        let spyRefreshControl = UIRefreshControlSpy()
        
        currentRefreshControl?.allTargets.forEach { target in
            currentRefreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
                spyRefreshControl.addTarget(target, action: Selector(action), for: .valueChanged)
            }
        }
        
        refreshControl = spyRefreshControl
    }
    
}

private class UIRefreshControlSpy: UIRefreshControl {
    private var _isRefreshing = false
    
    override var isRefreshing: Bool { _isRefreshing }
    
    override func beginRefreshing() {
        _isRefreshing = true
    }
    
    override func endRefreshing() {
        _isRefreshing = false
    }
}
