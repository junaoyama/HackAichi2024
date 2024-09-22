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
    var messageList: [ChatMessageType] = [] {
        // メッセージ設定時に呼ばれる
        didSet {
            messagesCollectionView.reloadData()
            messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        }
    }
    
    init(messageList: [ChatMessageType]) {
        self.messageList = messageList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ビューロード時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // messagesCollectionView
        messagesCollectionView.backgroundColor = .vcBackground
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        // messageInputBar
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.image = UIImage(systemName: "paperplane.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 23)))
        messageInputBar.inputTextView.placeholder = "質問を入力してね！"
        
        if let layout = self.messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.setMessageIncomingAvatarSize(.zero)
            layout.setMessageOutgoingAvatarSize(.zero)
            layout.messagesCollectionView.contentInset = UIEdgeInsets(top: 15)
            layout.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(left: 10)))
            layout.setMessageIncomingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(left: 10)))
            layout.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(right: 10)))
            layout.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(right: 10)))
        }
        
        messagesCollectionView.reloadData()
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
        return .cellBackground
    }

    // メッセージスタイル
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubbleOutline(isFromCurrentSender(message: message) ? .userCellBorder : .characterCellBorder)
    }
}

// MessagesLayoutDelegate
extension ChatMessagesViewController: MessagesLayoutDelegate {
    // messageBottomLabelの高さ
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 24
    }
    
    // headerViewのサイズ
    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize.zero
    }
}

fileprivate extension UIEdgeInsets {
    init(top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
}
