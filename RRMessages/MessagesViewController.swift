//
//  MessagesViewController.swift
//  Ragdoll Run
//
//  Created by Jacob Leiken on 6/4/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import UIKit
import SpriteKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        super.willBecomeActive(with: conversation)
        // Use this method to configure the extension and restore previously stored state.
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
        NSUbiquitousKeyValueStore.default.synchronize()
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
        super.willTransition(to: presentationStyle)
        // Use this method to prepare for the change in presentation style.
        removeAllChildViewControllers()
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
        super.didTransition(to: presentationStyle)
        // Use this method to finalize any behaviors associated with the change in presentation style.
        guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        // Remove any child view controllers that have been presented.
        removeAllChildViewControllers()
        
        var match: RunMatch
        if let activeMatch = RunMatch(message: conversation.selectedMessage) {
            match = activeMatch
        } else {
            match = RunMatch(particpantScores: [], active: false)
        }
        
        guard let controller = storyboard?.instantiateViewController(
            withIdentifier: GameMessageViewController.storyboardID)
            as? GameMessageViewController
            else { fatalError("Could not instantiate a ViewController") }
        controller.currentMatch = match
        controller.delegate = self
        
        addChild(controller)
        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            controller.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        controller.didMove(toParent: self)
    }
    
    private func removeAllChildViewControllers() {
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
}

protocol RRViewControllerDelegate: class {
    func expandView()
}

extension MessagesViewController: RRViewControllerDelegate {
    func expandView() {
        requestPresentationStyle(.expanded)
    }
}
