//
//  MessageTextView.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/15.
//

import UIKit

enum MessageSender {
    case myself
    case character
}

class MessageTextView: UITextView {
    var messageSender: MessageSender
    var textViewBackgroundColor: UIColor {
        switch messageSender {
        case .myself:
            return .systemGreen
        case .character:
            return .systemGray6
        }
    }

    init(sender: MessageSender) {
        self.messageSender = sender
        super.init(frame: .zero, textContainer: nil)
        setUpTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpTextView() {
        self.backgroundColor = textViewBackgroundColor
        self.layer.cornerRadius = 20
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
