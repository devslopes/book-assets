//
//  GameScene.swift
//  TikiBird
//
//  Created by Jacob Luetzow on 7/3/16.
//  Copyright © 2016 Devslopes. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    var tapSound: AVAudioPlayer!

    let totalGroundPieces = 3
    var groundPieces = [SKSpriteNode]()
    let groundSpeed: CGFloat = 3.5
    let groundResetXCoord: CGFloat = -514
    
    var bird: SKSpriteNode!
    var birdAtlas = SKTextureAtlas(named: "Bird")
    var birdFrames = [SKTexture]()
    
    //simulated jump physics
    var isJumping = false
    var touchDetected = false
    var jumpStartTime: CGFloat = 0.0
    var jumpCurrentTime: CGFloat = 0.0
    var jumpEndTime: CGFloat = 0.0
    let jumpDuration: CGFloat = 0.35
    let jumpVelocity: CGFloat = 500.0
    var currentVelocity: CGFloat = 0.0
    var jumpInertiaTime: CGFloat!
    var fallInertiatime:CGFloat!
    
    //Delta time
    var lastUpdateTimeInterval: CFTimeInterval = -1.0
    var deltaTime:CGFloat = 0.0
    
    //Obstacles
    var tikis = [SKNode]()
    let heightBetweenObstacles: CGFloat = 900
    let timeBetweenObstacles = 3.0
    let bottomTikiMaxYPos = 234
    let bottomTikiMinYPos = 380
    let tikiXStartPos: CGFloat = 830
    let tikiXDestroyPos: CGFloat = -187
    var moveObstacleAction: SKAction!
    var moveObstacleForeverAction: SKAction!
    var tikiTimer: Timer!
    
    //Collision categories
    let category_bird: UInt32 = 1 << 0
    let category_ground: UInt32 = 1 << 1
    let category_tiki: UInt32 = 1 << 2
    let category_score: UInt32 = 1 << 3
    
    override func didMove(to view: SKView) {
        initSetup()
        setupScenery()
        setupBird()
        startGame()
    }

    func didBegin(_ contact: SKPhysicsContact) {
        //Add game over here
        print("contact")
    }
    
    func initSetup() {
        jumpInertiaTime = jumpDuration * 0.7
        fallInertiatime = jumpDuration * 0.3
        
        moveObstacleAction = SKAction.moveBy(x: -groundSpeed, y: 0, duration: 0.02)
        moveObstacleForeverAction = SKAction.repeatForever(SKAction.sequence([moveObstacleAction]))
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        physicsWorld.contactDelegate = self
        
        //prepare sounds for playing when needed.
        let tapSoundURL = Bundle.main.url(forResource: "tap", withExtension: "wav")!
        do {
            tapSound = try AVAudioPlayer(contentsOf: tapSoundURL)
            print("DW: tap loaded")
        } catch {
            print("DW: Music not played")
        }
        tapSound.numberOfLoops = 0
        tapSound.prepareToPlay()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        groundMovement()
        
        //Calculate delta time
        deltaTime = CGFloat(currentTime - lastUpdateTimeInterval)
        lastUpdateTimeInterval = currentTime
        
        //Prevents problems with an anomaly that occurs when delta 
        //time is too long- apple does a similar thing in their code
        if lastUpdateTimeInterval > 1 {
            deltaTime = 1.0/60.0
            lastUpdateTimeInterval = currentTime
        }
        
        //this is called one time per touch, sets jump start time 
        //and sets current velocity to max jump velocity
        if touchDetected {
            touchDetected = false
            jumpStartTime = CGFloat(currentTime)
            currentVelocity = jumpVelocity
            tapSound.play()
        }
        
        //If we are jumping
        if isJumping {
            //How long we have been jumping
            let currentDuration = CGFloat(currentTime) - jumpStartTime
            //time to end jump
            if currentDuration >= jumpDuration {
                isJumping = false
                jumpEndTime = CGFloat(currentTime)
            } else {
                //Rotate the bird to a certain euler angle over a certian period of time
                if bird.zRotation < 0.5 {
                    bird.zRotation += 2.0 * CGFloat(deltaTime)
                }
                
                //Move the bird up
                bird.position = CGPoint(x: bird.position.x, y: bird.position.y + (currentVelocity * CGFloat(deltaTime)))
                
                //We don't decrease velocity until after the initial jump inertia has taken place
                if currentDuration > jumpInertiaTime {
                    currentVelocity -= (currentVelocity * CGFloat(deltaTime)) * 2
                }
            }
        }else { //If we aren't jumping then we are falling
            //Rotate the bird to a certain euler angle over a certian period of time
            if bird.zRotation > -0.5 {
                bird.zRotation -= 2.0 * CGFloat(deltaTime)
            }
            // move the bird down
            bird.position = CGPoint(x: bird.position.x, y: bird.position.y - (currentVelocity * CGFloat(deltaTime)))
            
            //only start increasing velocity after floating for a little bit
            if CGFloat(currentTime) - jumpEndTime > fallInertiatime{
                currentVelocity += currentVelocity * CGFloat(deltaTime)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDetected = true
        isJumping = true
    }
    
    func startGame(){
        for sprite in groundPieces {
            sprite.run(moveObstacleForeverAction)
        }
        tikiTimer = Timer(timeInterval: timeBetweenObstacles, target: self, selector: #selector(GameScene.createTikiSet(_:)), userInfo: nil, repeats: true)
        RunLoop.main.add(tikiTimer, forMode: RunLoopMode.defaultRunLoopMode)
        tikiTimer.fire()
    }
    
    func groundMovement() {
        for x in 0..<groundPieces.count {
            if groundPieces[x].position.x <= groundResetXCoord {
                if x != 0 {
                    groundPieces[x].position = CGPoint(x: groundPieces[x-1].position.x + groundPieces[x].size.width, y: groundPieces[x].position.y)
                } else {
                    groundPieces[x].position = CGPoint(x: groundPieces[groundPieces.count-1].position.x + groundPieces[x].size.width, y: groundPieces[x].position.y)
                }
            }
        }
    }
    
    func setupBird() {
        let totalImgs = birdAtlas.textureNames.count
        for x in 0..<totalImgs{
            let textureName = "Bird-\(x)"
            let texture = birdAtlas.textureNamed(textureName)
            birdFrames.append(texture)
        }
        
        bird = SKSpriteNode(texture: birdFrames[0])
        bird.zPosition = 4
        addChild(bird)
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bird.run(SKAction.repeatForever(SKAction.animate(with: birdFrames, timePerFrame: 0.2, resize: false, restore: true)))
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
        bird.physicsBody?.isDynamic = true
        bird.zPosition = 4
        bird.physicsBody?.categoryBitMask = category_bird
        bird.physicsBody?.collisionBitMask = category_ground | category_tiki
        bird.physicsBody?.contactTestBitMask = category_ground | category_tiki
    }
    
    func setupScenery(){
        //Add background sprites
        let bg = SKSpriteNode(imageNamed: "Sky")
        bg.size = CGSize(width: self.frame.width, height: self.frame.height)
        bg.position = CGPoint(x: 0, y: 0)
        bg.zPosition = 1
        self.addChild(bg)
        
        let mountains = SKSpriteNode(imageNamed: "Mountains")
        mountains.size = CGSize(width: self.frame.width, height: self.frame.height/4)
        mountains.position = CGPoint(x: 0, y: -self.frame.height / 2 + 200)
        mountains.zPosition = 2
        self.addChild(mountains)

        //Add ground sprites
        for x in 0..<totalGroundPieces {
            let sprite = SKSpriteNode(imageNamed: "Ground")
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
            sprite.physicsBody?.isDynamic = false
            sprite.physicsBody?.categoryBitMask = category_ground
            sprite.zPosition = 5
            groundPieces.append(sprite)
            let wSpacing:CGFloat = -sprite.size.width / 2
            let hSpacing = -self.frame.height / 2 + sprite.size.height / 2
            if x == 0 {
                sprite.position = CGPoint(x: wSpacing, y: hSpacing)
            } else {
                sprite.position = CGPoint(x: -(wSpacing * 2) + groundPieces[x-1].position.x, y: groundPieces[x-1].position.y)
            }
            self.addChild(sprite)
        }
    }
    
    func createTikiSet(_ timer: Timer) {
        let tikiSet = SKNode()
        //Set up Tikis and Score Collider, bottom tiki
        let bottomTiki = SKSpriteNode(imageNamed: "Tiki_Upright")
        tikiSet.addChild(bottomTiki)
        let rand = arc4random_uniform(UInt32(bottomTikiMaxYPos)) + UInt32(bottomTikiMinYPos)
        let yPos = -CGFloat(rand)
        bottomTiki.position = CGPoint(x: 0, y: CGFloat(yPos))
        bottomTiki.physicsBody = SKPhysicsBody(rectangleOf: bottomTiki.size)
        bottomTiki.physicsBody?.isDynamic = false
        bottomTiki.physicsBody?.categoryBitMask = category_tiki
        bottomTiki.physicsBody?.contactTestBitMask = category_bird
        
        //Top Tiki
        let topTiki = SKSpriteNode(imageNamed: "Tiki_Down")
        topTiki.position = CGPoint(x: 0, y: bottomTiki.position.y + heightBetweenObstacles)
        tikiSet.addChild(topTiki)
        topTiki.physicsBody = SKPhysicsBody(rectangleOf: topTiki.size)
        topTiki.physicsBody?.isDynamic = false
        topTiki.physicsBody?.categoryBitMask = category_tiki
        topTiki.physicsBody?.contactTestBitMask = category_bird
        
        tikis.append(tikiSet)
        tikiSet.zPosition = 4
        tikiSet.run(moveObstacleForeverAction)
        addChild(tikiSet)
        tikiSet.position = CGPoint(x: tikiXStartPos, y: tikiSet.position.y)
        
    }

}
