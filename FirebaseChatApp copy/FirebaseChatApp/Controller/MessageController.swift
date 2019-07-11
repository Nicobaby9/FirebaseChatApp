//
//  ViewController.swift
//  FirebaseChatApp
//
//  Created by sarkom-1 on 06/05/19.
//  Copyright © 2019 Aerials. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs,rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

class MessageController: UITableViewController {
    
    var cellId = "cellId"
    var message = [Messages]()
    
    var messagesDictionary = [String : Messages]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        setupBarButton()
        checkIfUserLoggedIn()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)

    }
    
    func observerUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Database.database().reference().child("user-message").child(uid)
        ref.observe(.childAdded,with:  { (snapshot) in
            let userId = snapshot.key
            Database.database().reference().child("user-message").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                self.fetchMessageWithMessage(messageId)
            },withCancel: nil)
        }, withCancel: nil)
    }
    var timer : Timer?
    
    fileprivate func fetchMessageWithMessage(_ messageId: String) {
        let messagesReference = Database.database().reference().child("message").child(messageId)
        
        messagesReference.observeSingleEvent(of: .value,with:  { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Messages(dictionary: dictionary)
                
                if let chatPartnerId = message.chatPartnerId(){
                    self.messagesDictionary[chatPartnerId] = message
                }
                
                self.attemptReloadOfTable()
            }
        },withCancel: nil)
    }
    
    fileprivate func attemptReloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadTable(){
        self.message = Array(self.messagesDictionary.values)
        self.message.sort(by: { (message1, message2) -> Bool in
            return message1.timestamp?.int32Value > message2.timestamp?.int32Value
        })
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let msg = message[indexPath.row]
        cell.message = msg
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messagez = message[indexPath.row]
        
        guard let chatPartnerId = messagez.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("user").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User(dictionary: dictionary)
            user.id = chatPartnerId
            self.showChatControllerForUser(user)
            
        }, withCancel: nil)
    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("user").child(uid).observeSingleEvent(of: .value,with:  { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                self.setupNavBarWithUser(user)
            }
        },withCancel: nil)
    }
    
    func setupNavBarWithUser(_ user: User) {
        
        message.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observerUserMessages()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.loadImageUsingCacheWithUrlString(user.profileImageUrl!)
        
        containerView.addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 5).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    }
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogOut), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func setupView() {
//        view.backgroundColor = UIColor(r: 35, g: 45, b: 54)
        view.backgroundColor = .white
        
    }
    func  showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    func setupBarButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain
            , target: self, action: #selector(handleLogOut))
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newMessage))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    @objc func newMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navigation = UINavigationController(rootViewController: newMessageController)
        self.present(navigation, animated: true, completion: nil)
    }
    @objc func handleLogOut(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginController()
        loginController.messageController = self
        self.present(loginController, animated: true, completion: nil)
    }

}

extension UIColor{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
