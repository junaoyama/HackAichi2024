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
    
    var type: CharacterImageType {
        if image.isGif {
            return .gif
        } else {
            return .image
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
            image = try! UIImage(gifName: "welcomeBot.gif")
        case .thinking:
            image = try! UIImage(gifName: "thinkingBot.gif")
        case .answer:
            image = UIImage(systemName: "3.circle")
        }
    }
}
