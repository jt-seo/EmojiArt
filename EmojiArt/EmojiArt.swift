//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by JT3 on 2020/08/23.
//  Copyright © 2020 JT. All rights reserved.
//

import Foundation

struct EmojiArt {
    var emojis = [Emoji]()
    private var emojiUniqueId = 0
    var backgroundImageURL: URL?
    
    mutating func addEmoji(text: String, x: Int, y: Int, size: Int) {
        let emoji = Emoji(text: text, x: x, y: y, size: size, id: emojiUniqueId)
        print("addEmoji: \(emoji)")
        emojis.append(emoji)
        emojiUniqueId += 1
    }
}

struct Emoji {
    let text: String
    var x: Int
    var y: Int
    var size: Int
    let id: Int
    
    fileprivate init (text: String, x: Int, y: Int, size: Int, id: Int) {
        self.text = text
        self.x = x
        self.y = y
        self.size = size
        self.id = id
    }
}
