//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by JT3 on 2020/08/23.
//  Copyright © 2020 JT. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(EmojiArtDocument.pallette.map{ String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: self.defaultEmojiSize))
                            .onDrag {
                                print("onDrag: \(emoji)")
                                return NSItemProvider(object: emoji as NSString)
                            }
                    }
                }
            }
            .padding()
            GeometryReader { geometry in
                ZStack {
                    Color.white
                    .edgesIgnoringSafeArea([.horizontal, .bottom])
                    .overlay(
                        Group {
                            if self.document.backgroundImage != nil {
                                Image(uiImage: self.document.backgroundImage!)
                                    .resizable()
                                    .edgesIgnoringSafeArea([.horizontal, .bottom])
                            }
                        }
                    )
                    .onDrop(of: ["Public.Image", "public.plain-text"], isTargeted: nil) { providers, location in
                        // location is in global coordinate system. (coordinate system of the entire device, top-left 0,0)
                        // geometry.frame(.global).origin has the position of the view containing this point.
                        // So we have to adjust the coordinate of point to have 0, 0 if it has the same value with the frame.origin
                        var location = geometry.convert(location, from: .global)
                        location = CGPoint(x: location.x - geometry.size.width / 2, y: location.y - geometry.size.height / 2)   // TODO: - bogus. why we should convert coordinate to center?
                        return self.drop(providers: providers, location: location)
                    }
                    
                    ForEach (self.document.emojis, id: \.id) { emoji in
                        Text(emoji.text)
                            .position(emoji.position(in: geometry.size))
                            .font(Font.system(size: emoji.fontSize))
                    }
                }
            }
            
        }
    }
    
    private func drop(providers: [NSItemProvider], location: CGPoint) -> Bool {
        if providers.loadFirstObject(ofType: URL.self, using: {
                print("imageUrl")
                self.document.setBackgroundImageURL($0)
        }) {
            return true
        }
        else if providers.loadFirstObject(ofType: String.self, using: { string in
            print("string")
            self.document.addEmoji(emoji: string, at: location, size: self.defaultEmojiSize) }) {
            return true
        }
        
        print("Can't find matching provider. count: \(providers.count)")
//        print("type not matched")
//        for item in providers {
//            print(item)
//
//            _ = item.loadObject(ofClass: String.self) { string, _ in
//                if let emoji = string {
//                    print("emoji find \(emoji)")
//                    DispatchQueue.main.async {
//                        self.document.addEmoji(emoji: emoji, at: location, size: self.defaultEmojiSize)
//                    }
//                }
//            }
//        }
        
        return false
    }
    
    private let defaultEmojiSize: CGFloat = 40
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
    }
}
