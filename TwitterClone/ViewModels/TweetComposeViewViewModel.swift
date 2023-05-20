//
//  TweetComposeViewViewModel.swift
//  TwitterClone
//
//  Created by Jiradet Amornpimonkul on 5/19/23.
//

import Foundation
import Combine
import FirebaseAuth

final class TweetComposeViewViewModel: ObservableObject {
    
    private var subscription: Set<AnyCancellable> = []
    
    @Published var isValidToTweet: Bool = false
    @Published var error: String = ""
    @Published var shouldDismissCompser: Bool = false
    var tweetContent: String = ""
    private var user: TwitterUser?
    
    func getUserData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUsers(retreive: userID)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] twitterUser in
                self?.user = twitterUser
            }
            .store(in: &subscription)
    }
    
    func validateToTweet() {
        isValidToTweet = !tweetContent.isEmpty
    }
    
    func dispatchTweet() {
        guard let user = user else { return }
        let tweet = Tweet(author: user, authorID: user.id, tweetContent: tweetContent, likesCount: 0, likers: [], isReply: false, parentReference: nil)
        DatabaseManager.shared.collectionTweets(dispatch: tweet)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] state in
                self?.shouldDismissCompser = state
            }
            .store(in: &subscription)

    }
    
}
