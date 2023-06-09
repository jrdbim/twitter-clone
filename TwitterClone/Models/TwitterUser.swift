//
//  TwitterUser.swift
//  TwitterClone
//
//  Created by Jiradet Amornpimonkul on 5/13/23.
//

import Foundation
import Firebase

struct TwitterUser: Codable {
    
    let id: String
    var displayName: String = ""
    var username: String = ""
    var followerCount: Int = 0
    var followingCount: Int = 0
    var createdOn: Date = Date()
    var bio: String = ""
    var avatarPath: String = ""
    var isUserOnboarded: Bool = false
    
    init(from user: User) {
        self.id = user.uid
    }
    
}
