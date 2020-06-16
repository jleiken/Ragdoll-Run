//
//  GameViewController.swift
//  RegularMaria
//
//  Created by Jacob Leiken on 5/13/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class GameViewController: UIViewController {
    
    private var _bannerView: GADBannerView?
    
    private static var _sharedSelf: GameViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        GameViewController._sharedSelf = self
        StoreObserver.shared.delegate = self
        StoreManager.shared.delegate = self
        StoreManager.shared.startProductRequest()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'MenuScene.sks'
            if let scene = MenuScene(fileNamed: "MenuScene") {
                // Set the scale mode to resize to fit the window
                scene.scaleMode = .resizeFill
                scene.controller = self
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
        }
        
        if !CloudVars.hideAds {
            // In this case, we instantiate the banner with desired ad size.
            _bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
            addBannerViewToView(_bannerView!)
            #if DEBUG
            _bannerView?.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            #else
            _bannerView?.adUnitID = "ca-app-pub-1525379522124593/1839912973"
            #endif
            _bannerView?.rootViewController = self
            _bannerView?.load(GADRequest())
        }
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        let guide = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            bannerView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            bannerView.leftAnchor.constraint(equalTo: guide.leftAnchor),
            bannerView.rightAnchor.constraint(equalTo: guide.rightAnchor),
        ])
    }
    
    static func hideAdsIfNecessary() {
        if let controller = _sharedSelf {
            controller._bannerView?.removeFromSuperview()
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: StoreAlertDelegate {
    func present(_ alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
}
