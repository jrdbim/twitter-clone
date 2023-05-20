//
//  TweetComposeViewController.swift
//  TwitterClone
//
//  Created by Jiradet Amornpimonkul on 5/19/23.
//

import UIKit
import Combine

class TweetComposeViewController: UIViewController {
    
    private var viewModel = TweetComposeViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private let tweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .twitterBlueColor
        button.setTitle("Tweet", for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.isEnabled = false
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .disabled)
        return button
    }()
    
    private let tweetContentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        textView.text = "What's happening"
        textView.textColor = .gray
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Tweet"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapToCancel))
        
        view.addSubview(tweetButton)
        view.addSubview(tweetContentTextView)
        
        tweetContentTextView.delegate = self
        
        tweetButton.addTarget(self, action: #selector(didTapToTweet), for: .touchUpInside)
        
        configureConstraints()
        bindView()
    }
    
    @objc private func didTapToTweet() {
        viewModel.dispatchTweet()
    }
    
    private func bindView() {
        viewModel.$isValidToTweet
            .sink { [weak self] state in
                self?.tweetButton.isEnabled = state
            }
            .store(in: &subscriptions)
        viewModel.$shouldDismissCompser
            .sink { [weak self] success in
                if success {
                    self?.dismiss(animated: true)
                }
            }.store(in: &subscriptions)
    }
    
    @objc private func didTapToCancel() {
        dismiss(animated: true)
    }
    
    private func configureConstraints() {
        let tweetButtonConstraint = [
            tweetButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10),
            tweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tweetButton.widthAnchor.constraint(equalToConstant: 120),
            tweetButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        let tweetContentTextViewConstraint = [
            tweetContentTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tweetContentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tweetContentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tweetContentTextView.bottomAnchor.constraint(equalTo: tweetButton.topAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(tweetButtonConstraint)
        NSLayoutConstraint.activate(tweetContentTextViewConstraint)
    }

}

extension TweetComposeViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray {
            textView.textColor = .label
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .gray
            textView.text = "What's happening"
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.tweetContent = textView.text
        viewModel.validateToTweet()
    }
    
}
