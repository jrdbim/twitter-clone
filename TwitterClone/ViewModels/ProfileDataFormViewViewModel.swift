//
//  ProfileDataFormViewViewModel.swift
//  TwitterClone
//
//  Created by Jiradet Amornpimonkul on 5/13/23.
//

import Foundation
import Combine

final class ProfileDataFormViewViewModel: ObservableObject {
    
    @Published var displayName: String?
    @Published var userName: String?
    @Published var bio: String?
    @Published var avatarPath: String?
    
}
