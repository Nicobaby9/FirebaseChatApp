//
//  User.swift
//  FirebaseChatApp
//
//  Created by sarkom-1 on 07/05/19.
//  Copyright © 2019 Aerials. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    
    init(dictionary: [String : AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
}
