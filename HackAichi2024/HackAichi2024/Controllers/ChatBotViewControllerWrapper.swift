//
//  ChatBotViewControllerWrapper.swift
//  HackAichi2024
//
//  Created by jun on 2024/10/06.
//

#if DEBUG

import SwiftUI

struct ChatBotViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ChatBotViewController {
        let chatBotViewController = ChatBotViewController()
        return chatBotViewController
    }
    
    func updateUIViewController(_ uiViewController: ChatBotViewController, context: Context) {
        return
    }
}

struct ChatBotViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        return ChatBotViewControllerWrapper()
    }
}

#endif
