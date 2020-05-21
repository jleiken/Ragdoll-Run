//
//  GameScene.swift
//  RegularMaria
//
//  Created by Jacob Leiken on 5/13/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    weak var controllerContainer : UIViewController?
    
    private var _activeScene : Bool?
    
    private var _avatarManager : AvatarManager?
    private var _worldGenerator : WorldGenerator?
    private var _groundHeight : CGFloat?
        
    override func didMove(to view: SKView) {
        // render the first part of the world
        _groundHeight = -self.size.height / 3
        _worldGenerator = WorldGenerator(groundHeight: _groundHeight!, startingPos: -self.size.width/2, scene: scene!)
        _worldGenerator!.renderChunk(size: CHUNK_SIZE)
        
        // initiliaze the avatar
        _avatarManager = AvatarManager(self.scene!, _groundHeight!)
        
        // notify the avatar manager of all collisions
        scene?.physicsWorld.contactDelegate = _avatarManager
        
        // add a camera to the scene
        let cameraNode = SKCameraNode()
        cameraNode.position = scene!.anchorPoint
        
        scene?.addChild(cameraNode)
        scene?.camera = cameraNode
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
            
            if touchedNode?.name == MENU_NAME {
                // touched menu icon, dismiss this popover
                controllerContainer?.dismiss(animated: true, completion: nil)
            } else if touchedNode?.name == PLAY_NAME {
                // touched play icon
                scene?.removeAllChildren()
                didMove(to: self.view!)
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
            scene?.camera?.position.x += CAMERA_SPEED
            _avatarManager!.walk(CAMERA_SPEED)
        }
    }
    
    func sceneActive() -> Bool {
        return _activeScene ?? false
    }
    
    func score() -> Int {
        return Int(scene!.camera!.position.x / 100)
    }
    
    func gameOver(_ scene : SKScene) {
        _activeScene = false
        _avatarManager?.removeSelf()
        
        let cameraX = scene.camera!.position.x
        
        // game over label
        let goText = SKLabelNode(text: "GAME OVER")
        goText.position.x = cameraX
        goText.position.y = 10
        goText.fontColor = SKColor.red
        goText.fontName = "AvenirNext-Heavy"
        goText.fontSize = 48
        scene.addChild(goText)
        
        // score label
        let scoreText = SKLabelNode(text: "Your score: \(score())")
        scoreText.position.x = cameraX
        scoreText.position.y = -40
        scoreText.fontName = "AvenirNext-Bold"
        scoreText.fontSize = 36
        scene.addChild(scoreText)
        
        // menu button
        let menuBut = SKLabelNode(text: "🏠 Menu")
        menuBut.fontName = "AvenirNext-Bold"
        // the position of the button should be the bottom left plus an offset from the sides of 10 pixels
        menuBut.position.x = cameraX - (scene.size.width / 2) + 65
        menuBut.position.y = -(scene.size.height / 2) + 60
        menuBut.fontSize = 28
        menuBut.fontColor = .red
        menuBut.name = MENU_NAME
        scene.addChild(menuBut)
        
        // play again button
        let playBut = SKLabelNode(text: "Play 🏃‍♀️")
        playBut.fontName = "AvenirNext-Bold"
        playBut.position.x = cameraX + (scene.size.width / 2) - 60
        playBut.position.y = menuBut.position.y
        playBut.fontColor = .red
        playBut.fontSize = 28
        playBut.name = PLAY_NAME
        scene.addChild(playBut)
    }
}
