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
    
    private let getBotResposeUseCase: AskChatBotUseCase = GetBotResponseUseCaseImpl()
    private let loadQAEntriesUseCase: LoadQAEntriesUseCase = LocalLoadQAEntriesUseCaseImpl()
    private let recommendUseCase: RecommendUseCase = RecommendUseCaseImpl()
    
    private var searchTask: Task<Void, any Error>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ChatBotColors.vcBackground
        
        characterImageViewModel = CharacterImageViewModel(state: .welcome)
        characterImageView = CharacterImageView(viewModel: characterImageViewModel)

        embedChildViewController()
        self.view.addSubview(characterImageView)
        
        setUpConstraints()
        
        Task {
            try await loadQAEntriesUseCase.loadIfNeed()
        }
        
        
    }

    private func embedChildViewController() {
        // 1. 子ViewControllerのインスタンスを作成
        let childVC = ChatMessagesViewController(messageList: [ChatMessageType.new(sender: MessageSenderType.character, message: ChatBotMessageTemplates.welcomeMessage)])
        self.messagesViewController = childVC
        self.messagesViewController?.messageInputBar.delegate = self
        self.messagesViewController?.messagesCollectionView.messageCellDelegate = self
        self.messagesViewController?.recommendView.delegate = self

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
            characterImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -30),
            characterImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            characterImageView.heightAnchor.constraint(equalToConstant: 280),
            messagesViewController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 200),
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
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            Task {
                let response = try await self.getBotResposeUseCase.askQuestion(userMessage)
                switch response {
                case .success(let message):
                    self.messagesViewController?.setTypingIndicatorViewHidden(true, animated: true, whilePerforming: {
                        DispatchQueue.main.async {
                            self.messagesViewController?.messageList.append(ChatMessageType.new(sender: MessageSenderType.character, message: message.content))
                            self.characterImageViewModel.state.goNextState(response: response)
                            self.characterImageView.apply(viewModel: self.characterImageViewModel)
                        }
                        self.messagesViewController?.messageInputBar.shouldManageSendButtonEnabledState = true
                        guard let isEmpty = self.messagesViewController?.messageInputBar.inputTextView.text.isEmpty else { return }
                        if !isEmpty {
                            self.messagesViewController?.messageInputBar.sendButton.isEnabled = true
                        }
                    })
                case .fail:
                    self.messagesViewController?.setTypingIndicatorViewHidden(true, animated: true, whilePerforming: {
                        DispatchQueue.main.async {
                            self.messagesViewController?.messageList.append(ChatMessageType.new(sender: MessageSenderType.character, message: ChatBotMessageTemplates.sorryMessage))
                            self.characterImageViewModel.state.goNextState(response: response)
                            self.characterImageView.apply(viewModel: self.characterImageViewModel)
                        }
                        self.messagesViewController?.messageInputBar.shouldManageSendButtonEnabledState = true
                        guard let isEmpty = self.messagesViewController?.messageInputBar.inputTextView.text.isEmpty else { return }
                        if !isEmpty {
                            self.messagesViewController?.messageInputBar.sendButton.isEnabled = true
                        }
                    })
                }
            }
        })
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        searchTask?.cancel()
        searchTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 300 * 1_000_000) // 300ms待
            if text.isEmpty {
                self.messagesViewController?.recommendView.set(text: "")
                return
            }
           
            if Task.isCancelled {
                return
            }
            let recommend = try await recommendUseCase.recommend(from: text)
            self.messagesViewController?.recommendView.set(text: recommend)
       }
   }

}

extension ChatBotViewController: MessageCellDelegate {
    // goodを押したときに呼ばれる
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("didTapGood")
        let cell = cell as! ChatBotMessageContentCell
        cell.didTapGoodButton()
    }
    
    // Badを押したときに呼ばれる
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("didTapBad")
        let cell = cell as! ChatBotMessageContentCell
        cell.didTapBadButton()
    }
}

extension ChatBotViewController: RecommendViewDelegate {
    func didTap(_ recommendView: RecommendView) {
        recommendView.isHidden = true
        messagesViewController?.messageInputBar.inputTextView.text = recommendView.text
    }
}
