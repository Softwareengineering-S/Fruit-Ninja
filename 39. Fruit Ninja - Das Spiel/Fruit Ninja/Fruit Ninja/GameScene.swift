//
//  GameScene.swift
//  Fruit Ninja
//
//  Created by Christian on 24.10.18.
//  Copyright © 2018 codingenieur. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GamePhase {
    case Ready
    case IsPlaying
    case GameOver
}

class GameScene: SKScene {
    
    var statusLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var bestScoreLabel = SKLabelNode()
    
    var score: Int = 0
    var bestScore: Int = 0
    var gamePhase: GamePhase = .Ready // Enum -> Auswahl von verschiedenen Fällen
    var missCount: Int = 3
    
    var createFruitTimer: Timer = Timer()
    
    var liveImageNodes = LiveNode()
    
    var defaults = UserDefaults.standard
    
    // MARK: - DidMove
    override func didMove(to view: SKView) { // Vergleichbar mit viewDidLoad()
        // Bestscore laden
        bestScore = defaults.integer(forKey: "bestScore")
        
        statusLabel = childNode(withName: "statusLabel") as! SKLabelNode
        
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLabel.text = "\(score)"
        
        bestScoreLabel = childNode(withName: "bestScoreLabel") as! SKLabelNode
        bestScoreLabel.text = "Best: \(bestScore)"
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -2)
        
        liveImageNodes = LiveNode(number: missCount)
        liveImageNodes.position = CGPoint(x: size.width - 60, y: size.height - 60)
        addChild(liveImageNodes)
    }
    
    // MARK: - Touches Stuff
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        if gamePhase == .Ready {
            gamePhase = .IsPlaying
            deleteNodesFromScene()
            startGame()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self) // Aktuelle Position
            let previousLocation = touch.previousLocation(in: self)
         
            print(location)
            print(previousLocation)
            
            for node in nodes(at: location) {
                if node.name == "fruit" {
                    score += 1
                    scoreLabel.text = "\(score)"
                    
                    createParticleEffect(position: node.position, filename: "FruitExplode.sks")
                    node.removeFromParent()
                    
                    let n = 1 + arc4random_uniform(UInt32(4)) // 1 - 4
                    playSoundEffect(soundFile: "Splatter\(n).wav")
                }
                
                if node.name == "bomb" {
                    
                    createParticleEffect(position: node.position, filename: "BombExplode.sks")
                    bombExloped()
                    gameOver()
                    
                    playSoundEffect(soundFile: "Bomb-explode.wav")
                }
            }
            
//            let path = CGMutablePath()
//            path.move(to: location)
//            path.addLine(to: previousLocation)
//
//            let line = SKShapeNode(path: path)
//            line.lineWidth = 8
//            line.strokeColor = .black
//            addChild(line)
//
//            line.run(SKAction.sequence([
//                SKAction.fadeAlpha(by: 0, duration: 0.2),
//                SKAction.removeFromParent()
//                ]))
            
            let line = TrackLine(currentPos: location, lastPos: previousLocation, width: 8, color: .red)
            addChild(line)
        }
    }
    
    // MARK: - Physics Stuff
    override func didSimulatePhysics() { // { Wird jedes Frame aufgerufen }
        for fruit in children {
            missFruit(fruit: fruit)
        }
    }
    
    // MARK: - Start and end - Game
    func startGame() {
       
        score = 0
        scoreLabel.text = "\(score)"
        missCount = 3
        
        liveImageNodes.reset()
        
        bestScoreLabel.text = "Best: \(bestScore)"
        
        fadeOut(node: statusLabel)
        
        createFruitTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { (_) in
            self.createFruits()
        })
    }
    
    func gameOver() {
        
        if score > bestScore {
            bestScore = score
            defaults.set(bestScore, forKey: "bestScore")
        }
        
        fadeIn(node: statusLabel)
        statusLabel.text = "Game Over..."
        
        createFruitTimer.invalidate()
        
        gamePhase = .GameOver
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (_) in
            self.gamePhase = .Ready
        }
    }
        
    
    // MARK: - Effekte
    func createFruits() {
        
        let numerOfFruits = 1 + Int(arc4random_uniform(UInt32(4))) // Tipp: Hier Schwierigkeitsgrad einstellen
        
        for _ in 0..<numerOfFruits {
            let fruit = Fruit()
            fruit.position.x = randomCGFloat(0, size.width)
            fruit.position.y = -100
            addChild(fruit)
            
            if fruit.position.x < size.width / 2 {
                fruit.physicsBody?.velocity.dx = randomCGFloat(0, 200)
            }
            
            if fruit.position.x > size.width / 2 {
                fruit.physicsBody?.velocity.dx = randomCGFloat(0, -200)
            }
            
            // Geschwindigkeit vom Fruit festlegen
            fruit.physicsBody?.velocity.dy = randomCGFloat(500, 800) // dy = Geschwindigkeit
            fruit.physicsBody?.angularVelocity = randomCGFloat(-5, 5) // Winkelgeschwindigkeit
        }
    }
    
    func missFruit(fruit: SKNode) {
        
        if fruit.position.y < -100 {
            if fruit.name == "fruit" {
                liveImageNodes.update(number: missCount)
                missCount -= 1
                print(missCount)
            }
            fruit.removeFromParent()
        }
        
        if missCount == 0 {
            gameOver()
        }
    }
    
    func bombExloped() {
        for case let fruit as Fruit in children { // Alle Fruits / Bomben werden gelöscht
            createParticleEffect(position: fruit.position, filename: "FruitExplode.sks")
            fruit.removeFromParent()
        }
    }
    
    func createParticleEffect(position: CGPoint, filename: String) {
            let emitterNode = SKEmitterNode(fileNamed: filename)
            emitterNode?.name = "explodeEffect"
            emitterNode?.position = position
            addChild(emitterNode!)
    }
    
    func deleteNodesFromScene() {
        for child in children {
            
            if child.name == "fruit" {
                child.removeFromParent()
            }
            
            if child.name == "bomb" {
                child.removeFromParent()
            }
            
            if child.name == "explodeEffect" {
                child.removeFromParent()
            }
        }
    }
    
   
    
    // MARK: - Helper methods
    func fadeOut(node: SKNode) {
        let waitAction = SKAction.wait(forDuration: 2)
        let fadeOutAction = SKAction.fadeOut(withDuration: 2)
        
        let actionsSeguence = SKAction.sequence([waitAction,fadeOutAction])
        
        node.run(actionsSeguence)
    }
    
    func fadeIn(node: SKNode) {
        let scaleAction = SKAction.scale(to: 1.2, duration: 0.2)
        let fadeInAction = SKAction.fadeIn(withDuration: 1)
        
        let actionsSeguence = SKAction.sequence([scaleAction,fadeInAction])
        
        node.run(actionsSeguence)
    }
    
    // MARK: - Play Sound
    func playSoundEffect(soundFile: String) {
        let audioNode = SKAudioNode(fileNamed: soundFile)
        audioNode.autoplayLooped = false
        addChild(audioNode)
        audioNode.run(SKAction.play())
        audioNode.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.removeFromParent()
            ]))
    }
}
