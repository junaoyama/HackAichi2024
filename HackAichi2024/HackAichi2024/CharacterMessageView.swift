//
//  CharacterMessageTextView.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/15.
//

import UIKit

class CharacterMessageView: UITextView {
    init() {
        super.init(frame: .zero, textContainer: nil)
        setUpTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTextView() {
        self.backgroundColor = .systemGray5
        self.isEditable = false
        self.layer.cornerRadius = 20
        self.translatesAutoresizingMaskIntoConstraints = false
    }

}
