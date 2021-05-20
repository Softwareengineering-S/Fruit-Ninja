//
//  TrackLine.swift
//  Fruit Ninja
//
//  Created by Christian on 29.10.18.
//  Copyright © 2018 codingenieur. All rights reserved.
//

import SpriteKit

class TrackLine: SKShapeNode {
    
    var shrinkTimer = Timer()
    
    init(currentPos: CGPoint, lastPos: CGPoint, width: CGFloat, color: UIColor) {
        super.init()
        
        // Pfad erstellen
        let path = CGMutablePath()
        path.move(to: currentPos)
        path.addLine(to: lastPos)
        
        self.path = path
        self.lineWidth = width
        self.strokeColor = color
        
        shrinkTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { (_) in
            self.lineWidth -= 1
            
            if self.lineWidth == 0 {
                self.shrinkTimer.invalidate()
                self.removeFromParent()
            }
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
