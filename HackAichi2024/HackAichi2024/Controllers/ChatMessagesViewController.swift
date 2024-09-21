//
//  ChatMessagesViewController.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/20.
//

import UIKit
import MessageKit
import InputBarAccessoryView

final class ChatMessagesViewController: MessagesViewController {

    // メッセージリスト
    private var messageList: [ChatMessageType] = [] {
        // メッセージ設定時に呼ばれる
        didSet {
            messagesCollectionView.reloadData()
            messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        }
    }
    
    private let getBotResposeUseCase: GetBotResponseUseCase = GetBotResponseUseCaseImpl()
    private let loadQAEntriesUseCase: LoadQAEntriesUseCase = LocalLoadQAEntriesUseCase()

    // ビューロード時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            // メッセージリストの初期化
            self.messageList = [
                ChatMessageType.new(sender: MessageSenderType.character, message: "ようこそ、質問を入力して送信してね"),
            ]
        }
        
        // messagesCollectionView
        messagesCollectionView.backgroundColor = UIColor.secondarySystemBackground
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        // messageInputBar
        messageInputBar.delegate = self
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.image = UIImage(systemName: "paperplane")
        
        if let layout = self.messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.setMessageIncomingAvatarSize(.zero)
            layout.setMessageOutgoingAvatarSize(.zero)
            layout.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(left: 10)))
            layout.setMessageIncomingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(left: 10)))
            layout.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(right: 10)))
            layout.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(right: 10)))
        }
        

        Task {
            let response = try await loadQAEntriesUseCase.loadIfNeed()
            print(response)
        }
        
        
    }
}

// MessagesDataSource
extension ChatMessagesViewController: MessagesDataSource {
    // 現在の送信者
    var currentSender: SenderType {
        return MessageSenderType.user
    }

    // メッセージ数
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }

    // IndexPathに応じたメッセージ
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }

    // messageTopLabelの属性テキスト
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(
            string: messageList[indexPath.section].sender.displayName,
            attributes: [.font: UIFont.systemFont(ofSize: 12.0), .foregroundColor: UIColor.systemBlue])
    }

    // messageBottomLabelの属性テキスト
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "HH:mm", options: 0, locale: Locale(identifier: "ja_JP"))
        return NSAttributedString(
            string: dateFormatter.string(from: messageList[indexPath.section].sentDate),
            attributes: [.font: UIFont.systemFont(ofSize: 12.0), .foregroundColor: UIColor.secondaryLabel])
    }
}

// MessagesDisplayDelegate
extension ChatMessagesViewController: MessagesDisplayDelegate {
    // 背景色
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.systemBlue : UIColor.systemBackground
    }

    // メッセージスタイル
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
//        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
//        return .bubbleTail(corner, .curved)
        return .bubble
    }

    // avaterViewの設定
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let sender = messageList[indexPath.section].sender as! MessageSenderType
        avatarView.image =  UIImage(named: sender.iconName)
    }
}

// MessagesLayoutDelegate
extension ChatMessagesViewController: MessagesLayoutDelegate {
    // messageTopLabelの高さ
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 24
    }

    // messageBottomLabelの高さ
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 24
    }
    
    // headerViewのサイズ
    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize.zero
    }
}

// InputBarAccessoryViewDelegate
extension ChatMessagesViewController: InputBarAccessoryViewDelegate {
    // InputBarAccessoryViewの送信ボタン押下時に呼ばれる
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        messageList.append(ChatMessageType.new(sender: MessageSenderType.user, message: text))
        messageInputBar.inputTextView.text = String()
        returnAnswer(question: text)
    }
    
    func returnAnswer(question: String) {
        messageList.append(ChatMessageType.new(sender: MessageSenderType.character, message: "・・・"))
        var answer = String()
        Task {
            let response = try await getBotResposeUseCase.respondToMessage(Message(id: UUID(), sender: .user, content: question, timestamp: Date()))
            answer = response.content
            messageList.append(ChatMessageType.new(sender: MessageSenderType.character, message: answer))
            print(response)
        }
        
    }
}

fileprivate extension UIEdgeInsets {
    init(top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
}
