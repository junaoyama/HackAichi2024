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

class GoodButton: UIButton {
    private var reactionType: ReactionType
    private var image: UIImage {
        switch reactionType {
        case .good:
            return UIImage(systemName: "hand.thumbsup.fill", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20)))!
        case .bad:
            return UIImage(systemName: "hand.thumbsdown.fill", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20)))!
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
        self.backgroundColor = .clear
        self.setImage(image, for: .normal)
        self.tintColor = .systemGray
//        self.layer.cornerRadius = 20
//        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

class GoodBadButton: UIStackView {
    private var goodButton: GoodButton!
    private var badButton: GoodButton!
    
    init() {
        super.init(frame: .zero)
        setUpView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.spacing = 20
        self.translatesAutoresizingMaskIntoConstraints = false
        
        goodButton = GoodButton(type: .good)
        self.addArrangedSubview(goodButton)
        
        badButton = GoodButton(type: .bad)
        self.addArrangedSubview(badButton)
    }
}


