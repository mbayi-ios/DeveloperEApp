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
    
    func numberOfRows(atSection section: Int) -> Int {
        tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section) : 0
    }
    
    func cell(at indexPath: IndexPath) -> UITableViewCell? {
        guard numberOfRows(atSection: indexPath.section) > indexPath.row else { return nil }
        return tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func isShowingLoadingIndicator() -> Bool {
        refreshControl?.isRefreshing == true
    }
    
    func simulateRefresh() {
        refreshControl?.sendActions(for: .valueChanged)
    }
    
    func title(at indexPath: IndexPath) -> String? {
        cell(at: indexPath)?.textLabel?.text
    }
    
    func subtitle(at indexPath: IndexPath) -> String? {
        cell(at: indexPath)?.detailTextLabel?.text?
            .replacingOccurrences(of: " ", with: " ")
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
