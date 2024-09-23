//
//  ChatBotMessageContentCell.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/22.
//

import UIKit
import MessageKit

class ChatBotMessageContentCell: MessageCollectionViewCell {
    override init(frame: CGRect) {
      super.init(frame: frame)
      contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      setupSubviews()
    }

    // MARK: Internal

    /// The `MessageCellDelegate` for the cell.
    weak var delegate: MessageCellDelegate?
    
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)

        return label
    }()

    /// 枠線部分
    private var messageContainerView: UIView = {
        let containerView = UIView()
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 20
        containerView.backgroundColor = .white
        containerView.layer.borderColor = UIColor.characterCellBorder.cgColor
        containerView.layer.borderWidth = 1.0
        return containerView
    }()

    private var goodButton: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "hand.thumbsup.fill"))
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    private var badButton: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "hand.thumbsdown.fill"))
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    func didTapGoodButton() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, animations: {
            self.goodButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.badButton.transform = CGAffineTransform.identity
            self.goodButton.tintColor = .systemPink
            self.badButton.tintColor = .darkGray
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0.2) {
                self.goodButton.transform = CGAffineTransform.identity
            }
        })
    }
    
    func didTapBadButton() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, animations: {
            self.goodButton.transform = CGAffineTransform.identity
            self.badButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.goodButton.tintColor = .darkGray
            self.badButton.tintColor = .systemBlue
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0.2) {
                self.badButton.transform = CGAffineTransform.identity
            }
        })
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.attributedText = nil
        messageLabel.text = nil
        goodButton.isHidden = true
        badButton.isHidden = true
    }

    /// Handle tap gesture on contentView and its subviews.
    override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        let touchLocation = gesture.location(in: self)
        switch true {
            case messageContainerView.frame
                .contains(touchLocation) && !cellContentView(canHandle: convert(touchLocation, to: messageContainerView)):
            delegate?.didTapMessage(in: self)
        case goodButton.frame.contains(touchLocation):
            delegate?.didTapCellTopLabel(in: self)
        case badButton.frame.contains(touchLocation):
            delegate?.didTapMessageBottomLabel(in: self)
        default:
            delegate?.didTapBackground(in: self)
      }
    }

    /// Handle long press gesture, return true when gestureRecognizer's touch point in `messageContainerView`'s frame
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }

    func setupSubviews() {
        contentView.addSubview(goodButton)
        contentView.addSubview(badButton)
        contentView.addSubview(messageContainerView)
        messageContainerView.addSubview(messageLabel)
    }

    func configure(
      with message: MessageType,
      at indexPath: IndexPath,
      in messagesCollectionView: MessagesCollectionView,
      dataSource: MessagesDataSource,
      and sizeCalculator: ChatBotMessageLayoutSizeCalculator)
    {
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            return
        }
        
        delegate = messagesCollectionView.messageCellDelegate
        
        messageContainerView.frame = sizeCalculator.messageContainerFrame(for: message, at: indexPath, fromCurrentSender: dataSource.isFromCurrentSender(message: message))
        goodButton.frame = sizeCalculator.goodButtonFrame(for: message, at: indexPath, fromCurrentSender: dataSource.isFromCurrentSender(message: message))
        badButton.frame = sizeCalculator.badButtonFrame(for: message, at: indexPath, fromCurrentSender: dataSource.isFromCurrentSender(message: message))
        messageLabel.frame = sizeCalculator.messageLabelFrame(for: message, at: indexPath)
        
        if case .custom(let text) = message.kind, let text = text as? NSAttributedString {
            messageLabel.attributedText = text
        } else {
            fatalError("非対応です")
        }
        
//        自分が一番下に存在しているか？
        if sizeCalculator.messagesLayout.lastMessage(indexPath) {
            if !sizeCalculator.messagesLayout.firstMessage(indexPath) {
                goodButton.isHidden = false
                badButton.isHidden = false
            } else {
                goodButton.isHidden = true
                badButton.isHidden = true
            }
        } else {
            goodButton.isHidden = true
            badButton.isHidden = true
        }
    }

    /// Handle `ContentView`'s tap gesture, return false when `ContentView` doesn't needs to handle gesture
    func cellContentView(canHandle _: CGPoint) -> Bool {
      false
    }
}
