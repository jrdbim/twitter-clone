//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by Jiradet Amornpimonkul on 4/29/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let statusBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0
        return view
    }()
    
    private var isStatusBarHidden = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        
        let headerView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 370))
        profileTableView.tableHeaderView = headerView
        profileTableView.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(profileTableView)
        view.addSubview(statusBarView)
        profileTableView.delegate = self
        profileTableView.dataSource = self
        configureConstraints()
    }
    
    private func configureConstraints() {
        let profileTableViewConstraints = [
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let statusBarViewConstraints = [
            statusBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBarView.topAnchor.constraint(equalTo: view.topAnchor),
            statusBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBarView.heightAnchor.constraint(equalToConstant: view.bounds.height > 800 ? 40 : 20)
        ]
        
        NSLayoutConstraint.activate(profileTableViewConstraints)
        NSLayoutConstraint.activate(statusBarViewConstraints)
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        
        if yPosition > 150 && isStatusBarHidden {
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
                self?.statusBarView.layer.opacity = 1
            }
        } else if yPosition < 0 && !isStatusBarHidden {
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
                self?.statusBarView.layer.opacity = 0
            }
        }
    }
    
}
