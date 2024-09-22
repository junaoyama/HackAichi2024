//
//  ChatBotViewController.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/20.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatBotViewController: UIViewController {
    private var messagesViewController: ChatMessagesViewController?
    private var characterImageView: CharacterImageView!
    private var characterImageViewModel: CharacterImageViewModel!
    
    private let getBotResposeUseCase: GetBotResponseUseCase = GetBotResponseUseCaseImpl()
    private let loadQAEntriesUseCase: LoadQAEntriesUseCase = LocalLoadQAEntriesUseCaseImpl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .vcBackground
        
        characterImageViewModel = CharacterImageViewModel(state: .welcome)

        embedChildViewController()
        
        characterImageView = CharacterImageView(viewModel: characterImageViewModel)
        self.view.addSubview(characterImageView)
        
        setUpConstraints()
        
        Task {
            try await loadQAEntriesUseCase.loadIfNeed()
        }
    }

    private func embedChildViewController() {
        // 1. 子ViewControllerのインスタンスを作成
        let childVC = ChatMessagesViewController(messageList: [ChatMessageType.new(sender: MessageSenderType.character, message: "ようこそ、質問を入力して送信してね")])
        self.messagesViewController = childVC
        self.messagesViewController?.messageInputBar.delegate = self
        self.messagesViewController?.messagesCollectionView.messageCellDelegate = self

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

// InputBarAccessoryViewDelegate
extension ChatBotViewController: InputBarAccessoryViewDelegate {
    
    // InputBarAccessoryViewの送信ボタン押下時に呼ばれる
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let userMessage = Message(id: UUID(), sender: .user, content: text, sentAt: Date())
        messagesViewController?.messageList.append(ChatMessageType.new(sender: MessageSenderType.user, message: userMessage.content))
        characterImageViewModel.state.goNextState()
        characterImageView.apply(viewModel: characterImageViewModel)
        messagesViewController?.messageInputBar.inputTextView.text = String()
        self.messagesViewController?.messageInputBar.shouldManageSendButtonEnabledState = false
        self.messagesViewController?.messageInputBar.sendButton.isEnabled = false
        self.messagesViewController?.setTypingIndicatorViewHidden(false, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
            Task {
                let response = try await self.getBotResposeUseCase.respondToMessage(userMessage)
                self.messagesViewController?.setTypingIndicatorViewHidden(true, animated: true, whilePerforming: {
                    DispatchQueue.main.async {
                        self.messagesViewController?.messageList.append(ChatMessageType.new(sender: MessageSenderType.character, message: response.content))
                        self.characterImageViewModel.state.goNextState()
                        self.characterImageView.apply(viewModel: self.characterImageViewModel)
                    }
                    self.messagesViewController?.messageInputBar.shouldManageSendButtonEnabledState = true
                    guard let isEmpty = self.messagesViewController?.messageInputBar.inputTextView.text.isEmpty else { return }
                    if !isEmpty {
                        self.messagesViewController?.messageInputBar.sendButton.isEnabled = true
                    }
                })
            }
        })
    }
}

extension ChatBotViewController: MessageCellDelegate {
    // goodを押したときに呼ばれる
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("didTapGood")
    }
    
    // Badを押したときに呼ばれる
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("didTapBad")
    }
}
