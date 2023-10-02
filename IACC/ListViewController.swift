//
//  ListViewController.swift
//  IACC
//
//  Created by Ambrose Mbayi on 02/10/2023.
//

import Foundation
import UIKit

class ListViewController: UITableViewController {
    var items = [Any]()
    
    var retryCount = 0
    var maxRetryCount = 0
    var shouldRetry = false
    
    var longDateStyle = false
    
    var fromFriendsScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        if fromFriendsScreen {
            shouldRetry = true
            maxRetryCount = 2
            
            title = "Friends"
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if tableView.numberOfRows(inSection: 0) == 0 {
            refresh()
        }
    }
    
    @objc private func refresh() {
        refreshControl?.beginRefreshing()
        
        if fromFriendsScreen {
            FriendsAPI.shared.loadFriends { [weak self] result in
                DispatchQueue.mainAsyncIfNeeded {
                    self?.handleAPIResult(result)
                }
            }
        } else {
            fatalError("Unknown context")
        }
    }
    
    private func handleAPIResult<T>(_ result: Result<[T], Error>) {
        switch result {
        case let .success(items):
            if fromFriendsScreen && User.shared?.isPremium == true {
                (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).cache.save(items as! [Friend])
            }
            
            
            self.retryCount = 0
            var filteredItems = items as [Any]
            
            self.items = filteredItems
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
            
            
        case let .failure(error):
            if shouldRetry && retryCount < maxRetryCount {
                retryCount += 1
                
                refresh()
                return
            }
            
            retryCount = 0
            
            if fromFriendsScreen && User.shared?.isPremium == true {
                (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).cache.loadFriends { [weak self] result in
                    DispatchQueue.mainAsyncIfNeeded {
                        switch result {
                        case let .success(items):
                            self?.items = items
                            self?.tableView.reloadData()
                            
                        case let .failure(error):
                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default))
                            self?.presenterVC.present(alert, animated: true)
                        }
                        self?.refreshControl?.endRefreshing()
                    }
                }
            } else {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.presenterVC.present(alert, animated: true)
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "ItemCell")
        cell.configure(item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        if let friend = item as? Friend {
            let vc = FriendDetailsViewController()
            vc.friend = friend
            navigationController?.pushViewController(vc, animated: true)
        } else {
            fatalError("Unknown item: \(item)")
        }
    }
    
    @objc func addFriend() {
        navigationController?.pushViewController(AddFriendViewController(), animated: true)
    }
    
}


extension UITableViewCell {
    func configure(_ item: Any) {
        if let friend = item as? Friend {
            textLabel?.text = friend.name
            detailTextLabel?.text = friend.phone
        } else {
            fatalError("unknown item: \(item)")
        }
    }
}
