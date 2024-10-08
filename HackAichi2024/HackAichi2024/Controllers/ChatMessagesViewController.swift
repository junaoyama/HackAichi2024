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
    
    var recommendView: RecommendView = RecommendView(frame: .zero)
    
    private lazy var chatBotMessageSizeCalculator = ChatBotMessageLayoutSizeCalculator(
      layout: self.messagesCollectionView
        .messagesCollectionViewFlowLayout)
    
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
        
        setUpMessagesCollectionView()
        setUpMessageInputBar()
        setUpLayout()
        setUpRecommendView()
        
        messagesCollectionView.reloadData()
    }
    
    private func setUpMessagesCollectionView() {
        messagesCollectionView.backgroundColor = ChatBotColors.vcBackground
        messagesCollectionView.register(ChatBotMessageContentCell.self)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    private func setUpMessageInputBar() {
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.image = UIImage(systemName: "paperplane.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 23)))
        messageInputBar.sendButton.tintColor = ChatBotColors.sendButton
        messageInputBar.inputTextView.placeholder = ChatBotMessageTemplates.placeholder
        messageInputBar.inputTextView.tintColor = ChatBotColors.inputCursor
        messageInputBar.inputTextView.font = .systemFont(ofSize: 20)
    }
    
    private func setUpLayout() {
        if let layout = self.messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.setMessageIncomingAvatarSize(.zero)
            layout.setMessageOutgoingAvatarSize(.zero)
            layout.messagesCollectionView.contentInset = UIEdgeInsets(top: 15)
            layout.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(left: 10)))
            layout.setMessageIncomingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(left: 10)))
            layout.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(right: 10)))
            layout.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(right: 10)))
        }
    }
    
    private func setUpRecommendView() {
        recommendView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(recommendView)
        
        NSLayoutConstraint.activate([
            recommendView.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor, multiplier: 0.8),
            recommendView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            recommendView.bottomAnchor.constraint(equalTo: self.messageInputBar.topAnchor, constant: -10)
        ])
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
        return ChatBotColors.cellBackground
    }

    // メッセージスタイル
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubbleOutline(isFromCurrentSender(message: message) ? ChatBotColors.userCellBorder : ChatBotColors.characterCellBorder)
    }
    
    func customCellSizeCalculator(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator {
        return chatBotMessageSizeCalculator
    }
    
    func customCell(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell {
        let cell = messagesCollectionView.dequeueReusableCell(ChatBotMessageContentCell.self, for: indexPath)
        cell.configure(with: message, at: indexPath, in: messagesCollectionView, dataSource: self, and: chatBotMessageSizeCalculator)
        return cell
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
