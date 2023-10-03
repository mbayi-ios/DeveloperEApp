//
//  NotImplementedViewControllers.swift
//  IACC
//
//  Created by Ambrose Mbayi on 02/10/2023.
//

import Foundation
import UIKit

class FriendDetailsViewController: NotImplementedViewController {
    var friend: Friend?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Friends Details"
    }
}

class AddFriendViewController: NotImplementedViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Friend"
    }
}

class AddCardViewController: NotImplementedViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Card"
    }
}

class SendMoneyViewController: NotImplementedViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Send Money"
    }
}

class RequestMoneyViewController: NotImplementedViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Request Money"
    }
}


class NotImplementedViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "Not implemented in this demo."
        label.translatesAutoresizingMaskIntoConstraints = false
        view?.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
