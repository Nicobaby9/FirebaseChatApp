

//
//  NewMessageController.swift
//  FirebaseChatApp
//
//  Created by sarkom-1 on 07/05/19.
//  Copyright © 2019 Aerials. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class NewMessageController: UITableViewController {

    
    let cellId = "cellid"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView()
        fetchUser()
    }
    
    func setupView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    func fetchUser() {
        Database.database().reference().child("user").observe(.childAdded,with:  { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let user = User(dictionary: dictionary)
                user.id = snapshot.key
                self.users.append(user)
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        cell.profileImageView.loadImageUsingCacheWithUrlString(user.profileImageUrl!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var messagesController: MessageController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            print("Dismiss Completed")
            let user = self.users[indexPath.row]
            self.messagesController?.showChatControllerForUser(user )
        }
    }

}
