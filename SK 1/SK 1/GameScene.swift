//
//  GameScene.swift
//  SK 1
//
//  Created by Alexandr Chubutkin on 06/12/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private var lastUpdate: TimeInterval = 0
    
    private var ground: SKSpriteNode?
    private var groundScrollSpeed = 100.0

    private let ToiletObstacleContainerName = "ToiletContainer"
    private let ToiletObstacleNodeName = "Toilet"
    private var obstacleSpeed = 120.0
    private var obstacleCreationTimer: TimeInterval = 0
    private var obstacleCreationInterval: Int = 1
    
    private var nextObstacleIndicatorUI: SKNode?
    private var nextObstacleIndicatorLabel: SKLabelNode?
    private var nextObstacleIndicatorText = "[n] toilet[s] forward"
    
    private var player: SKNode?
    private var gravity = 1500.0
    private var playerYVelocity = 0.0
    private var isGrounded = true
    private var positionYGround = -450.0
    private var jumpVelocity = 1400.0
    private var doubleJump = false
    
    private var distanceUI: SKLabelNode?
    private var distance = 0.0
    
    private var footstep_carpet_000: SKAudioNode?

    override func didMove(to view: SKView) {
        createGround()
        initUI()
        initAudio()
        initPlayer()
    }
    
    func createGround() {
        if let groundNode = self.childNode(withName: "//Ground") as? SKSpriteNode {
            let groundNodeClone = groundNode.copy() as? SKSpriteNode
            groundNodeClone?.position = CGPoint(x: groundNodeClone!.size.width, y: (groundNodeClone?.position.y)!)
            addChild(groundNodeClone!)
        }
    }
    
    func initUI() {
        self.nextObstacleIndicatorUI = self.childNode(withName: "//UI/NextObstacleIndicatorUI")
        self.nextObstacleIndicatorUI?.isHidden = false
        self.nextObstacleIndicatorUI?.childNode(withName: "IndicatorToiletTemplate")?.isHidden = true
        self.nextObstacleIndicatorUI?.alpha = 0
        
        let fontName = "Inika-Bold"
        
        self.nextObstacleIndicatorLabel = self.childNode(withName: "//UI/NextObstacleIndicatorUI/IndicatorLabel") as? SKLabelNode
        
        if let label = self.nextObstacleIndicatorLabel {
            label.fontName = fontName
        }
        
        self.distanceUI = self.childNode(withName: "//UI/DistanceTextLabel") as? SKLabelNode
        
        if let label = self.distanceUI {
            label.fontName = fontName
        }
    }
    
    func initAudio() {
        self.footstep_carpet_000 = self.childNode(withName: "footstep_carpet_000") as? SKAudioNode
    }
    
    func initPlayer() {
        self.player = self.childNode(withName: "//Player")
    }
    
    func createObstacles(_ dt: TimeInterval) {
        obstacleCreationTimer += dt
         
        if Int(obstacleCreationTimer.rounded()) > obstacleCreationInterval {
            let obstacleContainer = ObstacleContainer()
            obstacleContainer.name = ToiletObstacleContainerName
            obstacleContainer.isHidden = true
            
            let position = obstacleStartPosition()
            obstacleContainer.position = position
            obstacleContainer.zPosition = 10
            
            obstacleContainer.addChild(
                createObstacle()
            )
            
            if Int.random(in: 0...1) == 1 {
                let obstacle = createObstacle()
                obstacle.position = CGPoint(x: 0, y: obstacle.size.height + 10)
                obstacleContainer.addChild(obstacle)
            }
            
            self.addChild(obstacleContainer)
            
            obstacleCreationTimer = 0
            obstacleCreationInterval = Int.random(in: 1...5)
        }
    }
    
    func createObstacle() -> SKSpriteNode {
        let obstacleTexture = SKTexture(imageNamed: "ObstacleToilet")
        let obstacle = SKSpriteNode(texture: obstacleTexture)
        obstacle.name = ToiletObstacleNodeName
        obstacle.size = CGSize(width: 115, height: 155)
        
        /*
        let shader = SKShader(fileNamed: "2DTopdownShadow.fsh")
        obstacle.shader = shader
        
        let textureSize_vector_float2: vector_float2 = vector2(Float(obstacle.texture?.size().width ?? 0), Float(obstacle.texture?.size().height ?? 0))
        
        let uniforms: [SKUniform] = [
            SKUniform(name: "r", float: 1),
            SKUniform(name: "textureSize", vectorFloat2: textureSize_vector_float2)
        ]
        shader.uniforms = uniforms
        */
        
        return obstacle
    }
    
    func obstacleStartPosition() -> CGPoint {
        return CGPoint(x: 600, y: -420)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        /*
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
        */
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        /*
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
        */
    }
    
    func touchUp(atPoint pos : CGPoint) {
        /*
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
        */
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        */
        
        if self.isGrounded {
            self.playerYVelocity = self.jumpVelocity
            self.isGrounded = false
            self.doubleJump = false
        }
        
        if self.playerYVelocity > 0 && abs(self.playerYVelocity) < 800 && !doubleJump {
            self.playerYVelocity += self.jumpVelocity / 3
            self.doubleJump = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        */
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        */
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        */
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // The first time the update function is called we must initialize the
        // lastUpdate variable
        if self.lastUpdate == 0 { self.lastUpdate = currentTime }
        
        // Calculates how much time has passed since the last update
        let dt = currentTime - self.lastUpdate

        self.lastUpdate = currentTime

        moveGround(dt)
        
        createObstacles(dt)
        showObstacles()
        moveObstacles(dt)
        
        showNextObstacleIndicator()
        
        movePlayer(dt)
        
        updateDistance(dt)
    }
    
    func movePlayer(_ dt: TimeInterval) {
        if isGrounded {
            return
        }
        
        self.playerYVelocity -= self.gravity * CGFloat(dt)
        
        var position = CGPoint(x: (self.player?.position.x)!, y: (self.player?.position.y)!)
        position.y += self.playerYVelocity * CGFloat(dt)
        
        enumerateChildNodes(withName: "//\(self.ToiletObstacleContainerName)/\(self.ToiletObstacleNodeName)") { node, _ in
            if let playerSprite = self.player?.children.first {
                if playerSprite.intersects(node) {
                    self.player?.isHidden = true
                    if playerSprite.position.y - playerSprite.frame.height / 2 < node.position.y + node.frame.height / 2 {
                        self.playerYVelocity = self.jumpVelocity
                        return
                    } else {
                        self.player?.removeFromParent()
                    }
                }
            }
        }
        
        if position.y <= self.positionYGround {
            position.y = positionYGround
            self.playerYVelocity = 0
            self.isGrounded = true
            self.playGroundedSound()
        }
        
        self.player?.position = position
    }
    
    func playGroundedSound() {
        self.footstep_carpet_000?.run(SKAction.play())
    }
    
    func updateDistance(_ dt: TimeInterval) {
        self.distance += self.groundScrollSpeed / 100 * dt
        self.distanceUI?.text = String(format: "%.1f", self.distance)
    }
    
    func moveGround(_ dt: TimeInterval) {
        enumerateChildNodes(withName: "Ground") { node, _ in
            if let node = node as? SKSpriteNode {
                let moveAmount = CGFloat(self.groundScrollSpeed) * CGFloat(dt)
                node.position.x -= moveAmount
                
                if node.position.x < -node.size.width {
                    node.position.x += node.size.width * 2
                }
            }
        }
    }
    
    func showObstacles() {
        enumerateChildNodes(withName: ToiletObstacleContainerName) { node, _ in
            if node.position.x - 115 <= (self.scene?.size.width)! / 2 && node.isHidden {
                node.isHidden = false
            }
        }
    }
    
    func moveObstacles(_ dt: TimeInterval) {
        enumerateChildNodes(withName: ToiletObstacleContainerName) { node, _ in
            let moveAmount = CGFloat(self.obstacleSpeed) * CGFloat(dt)
            node.position.x -= moveAmount
   
            if node.position.x + 115 < -(self.scene?.size.width)! / 2 {
                node.removeFromParent()
            }
        }
    }
    
    func showNextObstacleIndicator() {
        enumerateChildNodes(withName: ToiletObstacleContainerName) { node, _ in
            if let node = node as? ObstacleContainer {
                if node.position.x <= 550 && !node.isLocked {
                    node.isLocked = true
                    self.setNextObstacleIndicator(node.children.count)
                }
            }
        }
    }
    
    func setNextObstacleIndicator(_ nextCount: Int) {
        self.nextObstacleIndicatorUI?.enumerateChildNodes(withName: "IndicatorToilet") { node, _ in
            node.removeFromParent()
        }
        self.nextObstacleIndicatorUI?.alpha = 1
        self.nextObstacleIndicatorUI?.removeAllActions()
        self.nextObstacleIndicatorUI?.run(SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.fadeOut(withDuration: 0.3)]))
        
        self.nextObstacleIndicatorLabel?.text = self.nextObstacleIndicatorText
            .replacingOccurrences(of: "[n]", with: String(nextCount))
  
        for index in 0...nextCount - 1 {
            let node = self.nextObstacleIndicatorUI?.childNode(withName: "IndicatorToiletTemplate")?.copy() as? SKSpriteNode
            
            if let node = node {
                node.isHidden = false
                node.name = "IndicatorToilet"
                node.position = CGPoint(x: node.position.x, y: node.position.y + node.size.height * CGFloat(index) + CGFloat(index) * 10)
                
                let originalScale = node.xScale
                node.setScale(originalScale - 0.08)
                node.alpha = 0
                
                node.run(SKAction.sequence([
                    SKAction.wait(forDuration: 0.06 * CGFloat(index)),
                    SKAction.group([
                        SKAction.sequence([
                            SKAction.scale(to: originalScale + 0.02, duration: 0.1),
                            SKAction.scale(to: originalScale, duration: 0.1)
                        ]),
                        SKAction.fadeIn(withDuration: 0.2)
                    ])
                ]))
                
                self.nextObstacleIndicatorUI?.addChild(node)
            }
        }
    }
}

open class ObstacleContainer : SKNode {
    var isLocked = false
}
