//
//  ChatBotMessageLayoutSizeCalculator.swift
//  HackAichi2024
//
//  Created by wakita tomoshige on 2024/09/21.
//

import Foundation
import MessageKit
import UIKit

//想定
//メッセージ部分
//        ボタン

//ChatBotのレイアウト計算をおこなうクラス
class ChatBotMessageLayoutSizeCalculator: CellSizeCalculator {
//    メッセージ表示部分のフォント
    var messageLabelFont = UIFont.preferredFont(forTextStyle: .body)
    
    init(layout: MessagesCollectionViewFlowLayout? = nil) {
        super.init()
        self.layout = layout
    }

//    枠線内で右側にどれくらいスペースが空いているか(左に比べてどれくらい右を偏らせるか)
    var cellMessageContainerRightPadding: CGFloat = 16
    
//  枠線部分の設定
    private var cellMessageContainerLeftMargin: CGFloat = 8
    private var cellMessageContainerRightMargin: CGFloat = 60
    
//    枠線に入っている文字列Labelの設定
    private var cellMessageContentVerticalPadding: CGFloat = 16
    private var cellMessageContentHorizontalPadding: CGFloat = 16
    
//    good or badボタンに関する設定
    var evaluateButtonSize: CGSize = .init(width: 24, height: 24)
    var evaluateButtonVerticalTopMargin: CGFloat = 5
//    goodボタンとbadボタンがどれくらい離れているか
    var evaluateButtonVerticalSpacing: CGFloat = 5

    var messagesLayout: MessagesCollectionViewFlowLayout {
        layout as! MessagesCollectionViewFlowLayout
    }

    var messageContainerMaxWidth: CGFloat {
        messagesLayout.itemWidth - cellMessageContainerRightMargin - cellMessageContainerLeftMargin
    }

    var messagesDataSource: MessagesDataSource {
        self.messagesLayout.messagesDataSource
    }

    override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let dataSource = messagesDataSource
        
        let message = dataSource.messageForItem(
            at: indexPath,
            in: messagesLayout.messagesCollectionView)
        let itemHeight = cellContentHeight(
            for: message,
            at: indexPath)
        
        if messagesLayout.lastMessage(indexPath) {
            return CGSize(
                width: messagesLayout.itemWidth,
                height: itemHeight + evaluateButtonSize.height + evaluateButtonVerticalTopMargin)
        } else {
            return CGSize(
                width: messagesLayout.itemWidth,
                height: itemHeight)
        }
    }

    private func cellContentHeight(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
         return messageContainerSize(
                for: message,
                at: indexPath).height
    }

    func messageContainerSize(
        for message: MessageType,
        at indexPath: IndexPath)
        -> CGSize {
            let labelSize = messageLabelSize(
              for: message,
              at: indexPath)
            let width = labelSize.width +
              cellMessageContentHorizontalPadding +
              cellMessageContainerRightPadding
            let height = cellMessageContentVerticalPadding + labelSize.height

            return CGSize(
              width: width,
              height: height)
        }

    func messageContainerFrame(
        for message: MessageType,
        at indexPath: IndexPath,
        fromCurrentSender: Bool)
        -> CGRect {
//            今回の設定では一番上にmessageContainer(枠線部分が来るため)
            let y = 0.0
            let size = messageContainerSize(
                for: message,
                at: indexPath)
            let origin: CGPoint
            //    左右にずらす処理
            if fromCurrentSender {
                let x = messagesLayout.itemWidth -
                size.width - cellMessageContainerRightMargin
                origin = CGPoint(x: x, y: y)
            } else {
                origin = CGPoint(
                    x: cellMessageContainerLeftMargin,
                    y: y)
            }
        
            return CGRect(
                origin: origin,
                size: size)
    }
    
//    テキストを表示している部分だけの大きさ
    func messageLabelSize(
      for message: MessageType,
      at _: IndexPath)
      -> CGSize {
          let attributedText: NSAttributedString
          let textMessageKind = message.kind
          
          switch textMessageKind {
          case .text(let text):
              attributedText = NSAttributedString(string: text, attributes: [.font: messageLabelFont])
          case .attributedText(let text):
              attributedText = text
          case .custom(let any):
              if let text = any as? NSAttributedString {
                  attributedText = text
              } else {
                  fatalError("未対応です")
              }
          default:
              fatalError("未対応です")
          }
          
          let maxWidth = self.messageContainerMaxWidth -
          cellMessageContainerRightPadding

          return attributedText.size(consideringWidth: maxWidth)
    }
    
    func messageLabelFrame(
      for message: MessageType,
      at indexPath: IndexPath)
    -> CGRect {
        let origin = CGPoint(
            x: cellMessageContentHorizontalPadding / 2,
            y: cellMessageContentVerticalPadding / 2)
        let size = messageLabelSize(
            for: message,
            at: indexPath)
        
        return CGRect(
            origin: origin,
            size: size)
    }
    
    func goodButtonFrame(
        for message: MessageType,
        at indexPath: IndexPath,
        fromCurrentSender: Bool)
        -> CGRect {
            let badButtonRect = badButtonFrame(for: message, at: indexPath, fromCurrentSender: fromCurrentSender)
            return CGRect(origin: CGPoint(x: badButtonRect.minX - evaluateButtonSize.width - evaluateButtonVerticalSpacing, y: badButtonRect.minY), size: evaluateButtonSize)
    }
    
    func badButtonFrame(
        for message: MessageType,
        at indexPath: IndexPath,
        fromCurrentSender: Bool)
        -> CGRect {
            let messageContainerFrame = messageContainerFrame(for: message, at: indexPath, fromCurrentSender: fromCurrentSender)
            let x = messageContainerFrame.maxX - evaluateButtonSize.width
            let y = messageContainerFrame.maxY + evaluateButtonVerticalTopMargin
            let size = evaluateButtonSize
    
        return CGRect(
            origin: CGPoint(x: x, y: y),
            size: size)
    }
}
