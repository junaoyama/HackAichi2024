//
//  CharacterImageViewModel.swift
//  HackAichi2024
//
//  Created by jun on 2024/09/22.
//

import UIKit

class CharacterImageViewModel {
    var state: CharacterState {
        didSet {
            setImage(state: state)
        }
    }
    
    var image: UIImage!
    
    init(state: CharacterState) {
        self.state = state
        setImage(state: state)
    }
    
    private func setImage(state: CharacterState) {
        switch state {
        case .welcome:
            image = UIImage(systemName: "1.circle")
        case .thinking:
            image = UIImage(systemName: "2.circle")
        case .answer:
            image = UIImage(systemName: "3.circle")
        }
    }
}
