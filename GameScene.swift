//
//  GameScene.swift
//  SpaceOdessey
//
//  Created by Hiruni Perera on 1/9/2025.
//

import Foundation
import SwiftUI
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var backgroundMusic: SKAudioNode?
    let selectedCharacter: String
    let orby: SKSpriteNode
    // MARK: - Game Properties
    let maxGoodHits = 5
    let maxBadHits = 5
    var correctHits = 0
    var incorrectHits = 0
    var gameHasEnded = false
    
    // Add a score label
    let scoreLabel = SKLabelNode(fontNamed: "SFProText-Bold")
    
    var isDraggingOrby = false
    let laserCategory: UInt32 = 0x1 << 0
    let meteorCategory: UInt32 = 0x1 << 1
    var meteorSpawnInterval: TimeInterval = 2.0
    let goodMeteorPrompts = ["3xK!", "cJ9#", "8*v1", "$a2R", "64n%", "Mz&7",
                             "Qw7$", "r9&X", "T2#b", "v8*L", "$P5m", "k3@Z",
                             "J6!p", "n1%W", "x4^R", "B7&s"]
    let badMeteorPrompts = ["6789", "abcd", "Wxyz", "0123", "Orine", "LMNO",
                            "1234", "qwert", "asdf", "pass", "test", "1111",
                            "0000", "aaaa", "zzzz", "love", "home", "user"]
    
    
    // Timer properties
    let timerDuration: TimeInterval = 50 // 50 seconds
    var timerElapsed: TimeInterval = 0
    var timerStarted = false
    
    // MARK: - Scoreboard properties
    let energyBarBG = SKSpriteNode(imageNamed: "EnergyBarBG") // background image of the bar
    let energyBarFill = SKSpriteNode(imageNamed: "EnergyBarFill") // actual progress
    let badHitIcon = SKSpriteNode(imageNamed: "BadHitIcon") // red X
    let goodHitIcon = SKSpriteNode(imageNamed: "GoodHitIcon") // green check
    let gemIcon = SKSpriteNode(imageNamed: "GemIcon") // diamond
    let badHitLabel = SKLabelNode(fontNamed: "SFProText-Bold")
    let goodHitLabel = SKLabelNode(fontNamed: "SFProText-Bold")
    let gemLabel = SKLabelNode(fontNamed: "SFProText-Bold")

    // MARK: - Initializer
    init(size: CGSize, selectedCharacter: String) {
        self.selectedCharacter = selectedCharacter
        self.orby = SKSpriteNode(imageNamed: selectedCharacter)
        super.init(size: size)
        self.scaleMode = .resizeFill
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        physicsWorld.contactDelegate = self
        
        if let musicURL = Bundle.main.url(forResource: "BackgroundPlayMusic", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            backgroundMusic?.autoplayLooped = true
            addChild(backgroundMusic!)
        }
        
        let background = SKSpriteNode(imageNamed: "GameViewBgd") // your image name
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1 // behind everything

        let widthScale = size.width / background.size.width
        let heightScale = size.height / background.size.height
        let scale = max(widthScale, heightScale) // ensures it covers the screen
        background.setScale(scale)
        addChild(background)

        
        // Setup Orby
        orby.position = CGPoint(x: size.width * 0.1, y: size.height / 2)
        orby.setScale(0.5)
        addChild(orby)
        
        setupScoreboard()
        
        // Setup score label
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = .white
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: 20, y: size.height - 20)
        scoreLabel.zPosition = 10
        addChild(scoreLabel)
        
        // Spawn meteors
        startSpawningMeteors()
        increaseDifficulty()
        
        startTimer()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDraggingOrby, let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Clamp Y position to stay on screen
        let halfHeight = orby.size.height / 2
        let minY = halfHeight
        let maxY = size.height - halfHeight
        let targetY = max(minY, min(location.y, maxY))
        
        // Smoothly move Orby to the target Y position
        let moveAction = SKAction.moveTo(y: targetY, duration: 0.1)
        moveAction.timingMode = .easeOut // smooth acceleration/deceleration
        orby.run(moveAction)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Only start dragging if touch begins on Orby
        if orby.contains(location) {
            isDraggingOrby = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Stop dragging when touch ends
        isDraggingOrby = false
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Also stop dragging if touch is cancelled
        isDraggingOrby = false
    }


    func startSpawningMeteors() {
        createMeteor()
        
        // Schedule the next meteor
        let wait = SKAction.wait(forDuration: meteorSpawnInterval)
        let spawnNext = SKAction.run { [weak self] in
            self?.startSpawningMeteors()
        }
        
        run(SKAction.sequence([wait, spawnNext]))
    }

    func increaseDifficulty() {
        let decreaseInterval = SKAction.run { [weak self] in
            guard let self = self else { return }
            if self.meteorSpawnInterval > 0.5 { // minimum speed
                self.meteorSpawnInterval -= 0.1
            }
        }
        
        let wait = SKAction.wait(forDuration: 5.0) // every 5 seconds
        run(SKAction.repeatForever(SKAction.sequence([wait, decreaseInterval])))
    }

    func createMeteor() {
        let meteorImage = Bool.random() ? "GoodMeteor" : "BadMeteor"
        let meteor = SKSpriteNode(imageNamed: meteorImage)
        meteor.name = "meteorite"
        let xStart = size.width + meteor.size.width / 2
        let yStart = CGFloat.random(in: meteor.size.height/2...(size.height - meteor.size.height/2))
        meteor.position = CGPoint(x: xStart, y: yStart)
        meteor.setScale(0.9)
        
        //Add physics body
        meteor.physicsBody = SKPhysicsBody(circleOfRadius: meteor.size.width / 3)
        meteor.physicsBody?.categoryBitMask = meteorCategory
        meteor.physicsBody?.contactTestBitMask = laserCategory
        meteor.physicsBody?.affectedByGravity = false
        meteor.physicsBody?.velocity = CGVector(dx: -200, dy: 0)
        
        // Pick random text from the correct array
        let text: String
        if meteorImage == "GoodMeteor" {
            text = goodMeteorPrompts.randomElement() ?? "4T%bat"
        } else {
            text = badMeteorPrompts.randomElement() ?? "Hello321"
        }
        
        // Add text label on top of meteor
        let label = SKLabelNode(text: text)
        label.fontName = "SFProText-Bold"
        label.fontSize = 40
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.zPosition = 1  // keep text above meteor
        label.position.x = -5
        meteor.addChild(label)
        
        addChild(meteor)
        
        // Fade out and remove when past Orby
        let moveDuration = size.width / 200.0 // based on velocity dx
        let waitUntilPastOrby = SKAction.wait(forDuration: moveDuration * 0.95)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let remove = SKAction.removeFromParent()
        meteor.run(SKAction.sequence([waitUntilPastOrby, fadeOut, remove]))
    }
    
    func fireLaser() {
        let laser = SKSpriteNode(imageNamed: "laser")
        laser.name = "laser"
        laser.size = CGSize(width: 200, height: 5)
        laser.position = CGPoint(x: orby.position.x + orby.size.width / 2 + laser.size.width / 2, y: orby.position.y)
        laser.physicsBody = SKPhysicsBody(rectangleOf: laser.size)
        laser.physicsBody?.categoryBitMask = laserCategory
        laser.physicsBody?.contactTestBitMask = meteorCategory
        laser.physicsBody?.affectedByGravity = false
        laser.physicsBody?.velocity = CGVector(dx: 400, dy: 0)
        addChild(laser)
        
        run(SKAction.playSoundFileNamed("laser.mp3", waitForCompletion: false))
    }
    
    // Collision detection
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node else { return }
        
        var laserNode: SKNode?
        var meteorNode: SKNode?
        
        if nodeA.name == "laser" && nodeB.name == "meteorite" {
            laserNode = nodeA
            meteorNode = nodeB
        } else if nodeB.name == "laser" && nodeA.name == "meteorite" {
            laserNode = nodeB
            meteorNode = nodeA
        } else {
            return
        }
        
        // Play explosion sound
        run(SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false))
        
        // Add explosion
        if let explosion = SKEmitterNode(fileNamed: "Explosion.sks") {
            explosion.position = meteorNode!.position
            explosion.particleScale = 0.3
            explosion.particleScaleRange = 0.1
            addChild(explosion)
            
            explosion.run(SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.removeFromParent()
            ]))
        }
        
        // Remove laser and meteor immediately
        laserNode?.removeFromParent()
        meteorNode?.removeFromParent()
        
        // Determine if meteor is good or bad
        if let meteorNode = meteorNode as? SKSpriteNode, let textNode = meteorNode.children.first as? SKLabelNode {
            let isGoodMeteor = meteorNode.texture?.description.contains("GoodMeteor") ?? true
            updateScore(correct: isGoodMeteor)
        }

    }
    
    func setupScoreboard() {
        // Energy bar background
        let topMargin: CGFloat = 50
        let sideMargin: CGFloat = 60
        let timerIcon = SKSpriteNode(imageNamed: "TimerIcon") // your icon image
        let gemCountBG = SKSpriteNode(imageNamed: "GemCountBG") // your badge image

        
        energyBarBG.position = CGPoint(x: sideMargin + energyBarBG.size.width / 2,
                                       y: size.height - topMargin - energyBarBG.size.height / 2)
        energyBarBG.zPosition = 20
        addChild(energyBarBG)
        
        // Energy bar fill (will resize to show progress)
        energyBarFill.anchorPoint = CGPoint(x: 0, y: 0.5) // resize from left
        energyBarFill.position = CGPoint(x: energyBarBG.position.x - energyBarBG.size.width/2, y: energyBarBG.position.y)
        energyBarFill.zPosition = 21
        addChild(energyBarFill)
        
        // Add timer icon
        timerIcon.position = CGPoint(
            x: energyBarBG.position.x - energyBarBG.size.width/2 + timerIcon.size.width/2 - 30,
            y: energyBarBG.position.y
        )
        
        timerIcon.zPosition = 22
        addChild(timerIcon)

        // Gems icon represents good hits
        gemIcon.position = CGPoint(x: size.width /*- sideMargin*/ - gemIcon.size.width / 2 - gemCountBG.size.width, y: size.height - topMargin - 20)
        gemIcon.zPosition = 22
        addChild(gemIcon)
        
        // Add a background image for the gem count
        gemCountBG.position = CGPoint(
                x: gemIcon.position.x - gemIcon.size.width / 2 + gemCountBG.size.width / 2 + 10,
                y: gemIcon.position.y
            )
        gemCountBG.zPosition = 21
        addChild(gemCountBG)
        
        gemLabel.fontSize = 28
        gemLabel.fontColor = .white
        gemLabel.position = CGPoint(x: 5, y: -5)
        gemLabel.text = "0"
        gemLabel.zPosition = 22
        gemCountBG.addChild(gemLabel)
        
    }
    
    func updateScore(correct: Bool) {
        if correct {
            correctHits += 1
        } else {
            incorrectHits += 1 
        }
        
        // Update the scoreboard UI
        updateScoreboard()
        
        // Check if the game should end
        if correctHits >= maxGoodHits {
            gameOver(success: true)
        } else if incorrectHits >= maxBadHits {
            gameOver(success: false)
        }
    }
    
    func updateScoreboard() {
        // Update energy bar
        let energyPercent = CGFloat(correctHits) / CGFloat(maxGoodHits)
        energyBarFill.xScale = energyPercent
        
        // Update gem count to reflect good hits
       gemLabel.text = "\(correctHits)"
    }

    func startTimer() {
        guard !timerStarted else { return }
        timerStarted = true
        timerElapsed = 0
        energyBarFill.xScale = 1.0

        // Animate energy bar shrinking over time
        let shrinkAction = SKAction.scaleX(to: 0, duration: timerDuration)
        energyBarFill.run(shrinkAction)

        // Schedule check for timer end
        let wait = SKAction.wait(forDuration: timerDuration)
        let timerEnd = SKAction.run { [weak self] in
            guard let self = self else { return }
            self.gameOver(success: false)
        }
        run(SKAction.sequence([wait, timerEnd]))
    }
    
    func gameOver(success: Bool) {
        guard !gameHasEnded else { return }
        gameHasEnded = true
        // Stop all actions (timer, meteors, lasers, etc.)
        removeAllActions()
        for node in children {
            node.removeAllActions()
        }
        
        // Remove remaining meteors and lasers
        enumerateChildNodes(withName: "meteorite") { node, _ in node.removeFromParent() }
        enumerateChildNodes(withName: "laser") { node, _ in node.removeFromParent() }
        
        backgroundMusic?.removeFromParent()
        backgroundMusic = nil
        
        // Present the SwiftUI view
        if success {
            presentSwiftUIView(MissionAccomplishedView(selectedCharacter: ""))
        } else {
            presentSwiftUIView(MissionIncompleteView(selectedCharacter: ""))
        }
        
    }
 
    func getViewController() -> UIViewController? {
        var responder: UIResponder? = self.view
        while responder != nil {
            if let vc = responder as? UIViewController {
                return vc
            }
            responder = responder?.next
        }
        return nil
    }
    
    func presentSwiftUIView<Content: View>(_ view: Content) {
        guard let viewController = getViewController() else { return }
        let hostingController = UIHostingController(rootView: view)
        hostingController.modalPresentationStyle = .fullScreen
        viewController.present(hostingController, animated: true)
    }
}
