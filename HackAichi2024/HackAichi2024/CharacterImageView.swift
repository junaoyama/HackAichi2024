//
//  CharactorImageView.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/15.
//

import UIKit

class CharacterImageView: UIImageView {

    override init(image: UIImage?) {
        super.init(image: image)
        setUpImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpImageView() {
        self.contentMode = .scaleAspectFit
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
