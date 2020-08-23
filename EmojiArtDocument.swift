//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by JT3 on 2020/08/23.
//  Copyright © 2020 JT. All rights reserved.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    static var pallette = "🤬🥰☃️🐒🐋🐳🐲⭐️🍎🌕"
    
    @Published var emojiArt = EmojiArt()
    
    @Published var backgroundImage: UIImage?
    var backgroundImageURL: URL?
    
    var emojis: [Emoji] {
        return emojiArt.emojis
    }
    
    func setBackgroundImageURL(_ url: URL?) {
        backgroundImageURL = url?.imageURL
        DispatchQueue.global(qos: .userInitiated).async {   // The task below might take long time. So it should work inside a background queue.
            if let url = self.backgroundImageURL, let image = try? Data(contentsOf: url) {
                DispatchQueue.main.async {  // This is UI work. So the update should be done inside the main queue.
                    self.backgroundImage = UIImage(data: image)
                }
            }
            else {
                print("setBackgroundImageURL failed!")
            }
        }
    }
    
    func addEmoji(emoji: String, at location: CGPoint, size: CGFloat) {
        print("addEmoji")
        emojiArt.addEmoji(text: emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
}

extension Emoji {
    func position(in rect: CGSize) -> CGPoint {
        print(self)
        var pos = CGPoint(x: CGFloat(self.x) + rect.width / 2, y: CGFloat(self.y) + rect.height / 2)
        print(pos)
        print("rect: \(rect)")
        return pos
    }
    
    var fontSize: CGFloat {
        CGFloat(self.size)
    }
}
