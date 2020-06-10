//
//  GameScene.swift
//  RegularMaria
//
//  Created by Jacob Leiken on 5/13/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: MessagesScene {
    
    private var _activeScene: Bool?
    private var _cameraSpeed: CGFloat?
    private let DEFAULT_SPEED: CGFloat = 5
    
    private var _avatarManager: AvatarManager?
    private var _worldGenerator: WorldGenerator?
    private var _groundHeight: CGFloat?
    
    var messageVC: GameMessageViewController?
        
    override func didMove(to view: SKView) {
        // use our nice blue background
        scene?.backgroundColor = Formats.BACKGROUND
        
        // render the first part of the world
        _groundHeight = -self.size.height / 3
        _worldGenerator = WorldGenerator(groundHeight: _groundHeight!, startingPos: -self.size.width/2, scene: scene!)
        _worldGenerator!.renderChunk(size: CHUNK_SIZE)
        
        // initiliaze the avatar and make it the contact delegate
        _avatarManager = AvatarManager(scene: self.scene!, groundHeight: _groundHeight!)
        scene?.physicsWorld.contactDelegate = _avatarManager
        
        // add a camera to the scene
        let cameraNode = SKCameraNode()
        cameraNode.position = scene!.anchorPoint
        scene?.addChild(cameraNode)
        scene?.camera = cameraNode
        let divisor: CGFloat = 125
        _cameraSpeed = (scene?.size.width ?? divisor*DEFAULT_SPEED)/divisor
        
        _activeScene = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if sceneActive() {
            _avatarManager?.isTouching = true
        } else {
            let touch = touches.first
            let positionInScene = touch!.location(in: self)
            // the node they touched
            let touchedNode = self.nodes(at: positionInScene).first
            
            if touchedNode?.name == SpriteNames.MENU_NAME {
                // touched menu icon, dismiss this popover
                presentScene(
                    view, makeScene(of: MenuScene.self, with: "MenuScene"),
                    transition: SKTransition.doorsCloseHorizontal(withDuration: 0.2))
            } else if touchedNode?.name == SpriteNames.PLAY_NAME {
                // touched play icon
                scene?.removeAllChildren()
                didMove(to: self.view!)
            } else if touchedNode?.name == SpriteNames.SCORE_NAME {
                messageVC?.toScores()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if sceneActive() {
            _avatarManager?.isTouching = false
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if sceneActive() {
            _avatarManager?.isTouching = false
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        // only if the scene is active should we try to update anything
        if sceneActive() {
            // check if the avatar is off screen, end the game if so
            if _avatarManager!.offScreen() {
                gameOver(scene!)
                return
            }
            
            // let the avatar jump if they're on the platform
            _avatarManager?.letAvatarJump()
            
            // render the next section of the level if we're close to the end
            if _worldGenerator?.shouldRenderNextChunk(scene?.camera?.position.x) ?? false {
                _worldGenerator!.renderChunk(size: CHUNK_SIZE)
            }
            
            // move the camera one cameraSpeed increment to the right along with the avatar
            let inc = _cameraSpeed ?? DEFAULT_SPEED
            scene?.camera?.position.x += inc
            _avatarManager!.walk(inc)
        }
    }
    
    func sceneActive() -> Bool {
        return _activeScene ?? false
    }
    
    func calcScore() -> Int {
        return Int(scene!.camera!.position.x / 100)
    }
    
    func gameOver(_ scene : SKScene) {
        _activeScene = false
        
        let cameraX = scene.camera!.position.x
        
        // game over label
        let goText = SKLabelNode(text: "GAME OVER")
        goText.position.x = cameraX
        goText.position.y = 10
        goText.fontColor = SKColor.red
        goText.fontName = Formats.TITLE_FONT
        goText.fontSize = 48
        scene.addChild(goText)
        
        // score label
        let score = calcScore()
        let scoreText = SKLabelNode(text: "Your score: \(score)")
        scoreText.position.x = cameraX
        scoreText.position.y = -40
        scoreText.fontName = Formats.EMPHASIS_FONT
        // is it a high score? if so, set it and modify the a label
        if score > highScore {
            highScore = Int64(score)
            scoreText.text = "New high score: \(score)!"
            scoreText.fontColor = .green
        }
        scene.addChild(scoreText)
        
        // if we're in the messages version, send the score message to the chat and show a button to go to the scores view
        // if we're not, have replay and menu buttons
        if let vc = messageVC {
            vc.sendScore(score)
            
            let scoreBut = SKLabelNode(text: "See scores")
            scoreBut.fontName = Formats.EMPHASIS_FONT
            // the position of the button should be the bottom left plus an offset from the sides of 10 pixels
            scoreBut.position.x = cameraX
            scoreBut.position.y = -(scene.size.height / 2) + 60
            scoreBut.fontSize = 28
            scoreBut.fontColor = .red
            scoreBut.name = SpriteNames.SCORE_NAME
            scene.addChild(scoreBut)
        } else {
            // menu button
            let menuBut = SKLabelNode(text: "🏠 Menu")
            menuBut.fontName = Formats.EMPHASIS_FONT
            // the position of the button should be the bottom left plus an offset from the sides of 10 pixels
            menuBut.position.x = cameraX - (scene.size.width / 2) + 65
            menuBut.position.y = -(scene.size.height / 2) + 60
            menuBut.fontSize = 28
            menuBut.fontColor = .red
            menuBut.name = SpriteNames.MENU_NAME
            scene.addChild(menuBut)
            
            // play again button
            let playBut = SKLabelNode(text: "Play 🏃‍♀️")
            playBut.fontName = Formats.EMPHASIS_FONT
            playBut.position.x = cameraX + (scene.size.width / 2) - 60
            playBut.position.y = menuBut.position.y
            playBut.fontColor = .red
            playBut.fontSize = 28
            playBut.name = SpriteNames.PLAY_NAME
            scene.addChild(playBut)
        }
    }
}
