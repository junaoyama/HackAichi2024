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

fileprivate class SelectableButton: UIButton {
    private var reactionType: ReactionType
    private var image: UIImage {
        switch reactionType {
        case .good:
            return UIImage(systemName: "hand.thumbsup")!
        case .bad:
            return UIImage(systemName: "hand.thumbsdown")!
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
        self.setImage(image, for: .normal)
        self.tintColor = .white
        self.layer.cornerRadius = 20
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

class GoodBadButton: UIStackView {
    private var goodButton: SelectableButton!
    private var badButton: SelectableButton!
    
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
        
        goodButton = SelectableButton(type: .good)
        self.addArrangedSubview(goodButton)
        
        badButton = SelectableButton(type: .bad)
        self.addArrangedSubview(badButton)
    }
}


