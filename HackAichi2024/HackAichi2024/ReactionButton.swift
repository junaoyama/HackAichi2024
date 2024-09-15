//
//  ReactionButton.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/15.
//

import UIKit

enum ReactionType {
    case good
    case bad
}

class ReactionButton: UIButton {
    private var reactionType: ReactionType
    private var imageSystemName: String {
        switch reactionType {
        case .good:
            return "hand.thumbsup"
        case .bad:
            return "hand.thumbsdown"
        }
    }
    
    init(type: ReactionType) {
        reactionType = type
        super.init(frame: .zero)
        setUpButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpButton() {
        self.backgroundColor = .systemBlue
        self.setImage(UIImage(systemName: imageSystemName), for: .normal)
        self.tintColor = .white
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 20
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
