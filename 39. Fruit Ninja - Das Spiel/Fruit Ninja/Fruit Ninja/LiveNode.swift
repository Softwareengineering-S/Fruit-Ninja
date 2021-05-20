//
//  LiveNode.swift
//  Fruit Ninja
//
//  Created by Christian on 29.10.18.
//  Copyright © 2018 codingenieur. All rights reserved.
//

import SpriteKit

class LiveNode: SKNode {
    
    var liveArray = [SKSpriteNode]()
    var numberOfLive = Int()
    
    let blackLiveTexture = SKTexture(imageNamed: "black_miss")
    let redLiveTexture = SKTexture(imageNamed: "red_miss")
    
    init(number: Int = 0) {
        super.init()
        
        numberOfLive = number
        
        for i in 0..<number {
            let blackLive = SKSpriteNode(imageNamed: "black_miss")
            blackLive.size = CGSize(width: 60, height: 60)
            blackLive.position.x = -CGFloat(i) * 70
            addChild(blackLive)
            liveArray.append(blackLive)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(number: Int) {
        if number <= numberOfLive && number > 0 {
            liveArray[liveArray.count - number].texture = redLiveTexture
            print("Rot")
        }
    }
    
    func reset() {
        for node in liveArray {
            node.texture = blackLiveTexture
        }
    }
}
