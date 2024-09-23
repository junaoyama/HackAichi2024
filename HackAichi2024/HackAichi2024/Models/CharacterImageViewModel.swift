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
    var loopCount: Int = -1
    var interval: Double = 0
    
    init(state: CharacterState) {
        self.state = state
        setImage(state: state)
    }
    
    private func setImage(state: CharacterState) {
        switch state {
        case .welcome:
            let randomValue = Int.random(in: 1...3)
            if randomValue == 1 {
                image = try! UIImage(gifName: "welcomeBot.gif")
            } else {
                image = try! UIImage(gifName: "welcomeRareBot.gif")
            }
            
//            loopCount = 1
            interval = 1.5
        case .thinking:
            image = try! UIImage(gifName: "thinkingBot.gif")
//            loopCount = 1
            interval = 0.3
        case .answer:
            image = try! UIImage(gifName: "answerableBot.gif")
//            loopCount = 1
            interval = 1.5
        case .unknown:
            image = try! UIImage(gifName: "sorryBot.gif")
//            loopCount = 1
            interval = 1.5
        }
    }
}
