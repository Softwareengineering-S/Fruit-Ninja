//
//  Fruit.swift
//  Fruit Ninja
//
//  Created by Christian on 25.10.18.
//  Copyright © 2018 codingenieur. All rights reserved.
//

import Foundation
import SpriteKit

class Fruit: SKNode {
    
    let fruitsEmoji = ["🍏", "🍎", "🍐", "🍊", "🍌", "🍇", "🍓", "🥝"]
    
    let bombEmoji = "💣"
    
    override init() {
        super.init()
        
        var emoji: String = ""
        
        if randomCGFloat(0, 1) < 0.9 { // Erstelle eine Frucht
            name = "fruit"
            
            let numberN = Int(arc4random_uniform(UInt32(fruitsEmoji.count))) // Zahl zwischen 0 - 7
            emoji = fruitsEmoji[numberN]
            
        } else { // Sonst erstelle die Bombe
            name = "bomb"
            emoji = bombEmoji
        }
        
        let label = SKLabelNode(text: emoji)
        label.fontSize = 100
        label.verticalAlignmentMode = .center
        addChild(label)
        
        physicsBody = SKPhysicsBody()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
