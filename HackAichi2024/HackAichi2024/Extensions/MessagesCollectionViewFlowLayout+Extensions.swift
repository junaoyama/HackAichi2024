//
//  MessagesCollectionViewFlowLayout+Extensions.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/22.
//

import Foundation
import MessageKit

extension MessagesCollectionViewFlowLayout {
    func lastMessage(_ indexPath: IndexPath) -> Bool {
        let messagesCollectionView = self.messagesCollectionView
        
        //表示されているメッセージの数
        let displayedMessageNum = messagesDataSource.numberOfSections(in: messagesCollectionView)
        let sectionCount = messagesCollectionView.isTypingIndicatorHidden ? displayedMessageNum : displayedMessageNum + 1
        
//        indexPathのsectionは0スタートであるため
        return indexPath.section + 1 == sectionCount
    }
}
