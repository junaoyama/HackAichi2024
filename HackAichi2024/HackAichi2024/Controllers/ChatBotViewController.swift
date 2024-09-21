//
//  ChatBotViewController.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/20.
//

import UIKit
import MessageKit

class ChatBotViewController: UIViewController {
    private var messagesViewController: ChatMessagesViewController?
    private var characterImageView: CharacterImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        embedChildViewController()
        
        characterImageView = CharacterImageView(image: UIImage(named: "chatbot_charactor_1"))
        self.view.addSubview(characterImageView)
        
        setUpConstraints()
    }

    private func embedChildViewController() {
        // 1. 子ViewControllerのインスタンスを作成
        let childVC = ChatMessagesViewController()
        self.messagesViewController = childVC

        // 2. 子ViewControllerを親に追加
        self.addChild(childVC)

        // 3. 子ViewControllerのビューを親のビューに追加
        self.view.addSubview(childVC.view)
        // 4. 子ViewControllerのビューのレイアウトを設定
        childVC.view.translatesAutoresizingMaskIntoConstraints = false
        // 5. 子ViewControllerのライフサイクルを完了
        childVC.didMove(toParent: self)
    }
    
    private func setUpConstraints() {
        guard let messagesViewController else { return }
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            characterImageView.heightAnchor.constraint(equalToConstant: 200),
            messagesViewController.view.topAnchor.constraint(equalTo: self.characterImageView.bottomAnchor),
            messagesViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            messagesViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            messagesViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }

    @objc private func removeChildVC() {
        guard let childVC = self.messagesViewController else { return }

        // ライフサイクルの通知
        childVC.willMove(toParent: nil)

        // ビューを削除
        childVC.view.removeFromSuperview()

        // 親から削除
        childVC.removeFromParent()

        self.messagesViewController = nil
    }

}
