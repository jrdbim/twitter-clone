//
//  HomeViewViewModel.swift
//  TwitterClone
//
//  Created by Jiradet Amornpimonkul on 5/13/23.
//

import Foundation
import Combine
import FirebaseAuth

final class HomeViewViewModel: ObservableObject {
    
    @Published var user: TwitterUser?
    @Published var error: String?
    @Published var tweets: [Tweet] = []
    
    private var subscription: Set<AnyCancellable> = []
    
    func retreiveUser() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUsers(retreive: id)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.user = user
                self?.fetchTweets()
            })
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscription)
    }
    
    func fetchTweets() {
        guard let userID = user?.id else { return }
        DatabaseManager.shared.collectionTweets(retreuveTweets: userID)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] tweet in
                self?.tweets = tweet
            }
            .store(in: &subscription)

    }
    
}
