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
    
    // MARK: - State
    var markedReady: Bool = false
    private var _currentMatch: RunMatch? = nil
    private weak var _currentSession: MSSession? = nil
    
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
        
        _currentSession = conversation.selectedMessage?.session
        _currentMatch = matchFromConvo(from: conversation)
        
        if (_currentMatch?.particpantScores.filter({ $0.participant == conversation.localParticipantIdentifier }).count ?? 0) > 0 {
            // If we've already played, show scores
            presentMessagesView(newView: .score)
        } else if markedReady {
            // This means that we've tapped the ready button and expanded the view,
            // so start right off
            presentMessagesView(newView: .play)
        } else {
            // Otherwise present the ready screen
            presentMessagesView(newView: .ready)
        }
    }
    
    fileprivate func matchFromConvo(from conversation: MSConversation) -> RunMatch {
        var match: RunMatch
        if let activeMatch = RunMatch(message: conversation.selectedMessage) {
            match = activeMatch
        } else {
            match = RunMatch()
        }
        
        return match
    }
    
    fileprivate func presentViewController(_ controller: UIViewController) {
        // Remove any child view controllers that have been presented.
        removeAllChildViewControllers()
        
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
            // for some god forsaken reason iMessage asks us to present twice then doesn't
            // actually destroy the scene, so set it to inactive
            if let view = child.view as? SKView {
                view.scene?.isPaused = true
            }
            child.removeFromParent()
        }
    }
}

extension MessagesViewController: MessagesViewPresenter {
    
    func markReady(_ ready: Bool) {
        markedReady = ready
    }
    
    func clearConversation() {
        _currentMatch = RunMatch()
        _currentSession = nil
    }
    
    func presentMessagesView(newView: MessagesView) {
        var controller: ViewControllerTransferer?
        switch newView {
        case .ready:
            controller = storyboard?.instantiateViewController(
                withIdentifier: ReadyViewController.storyboardID)
                as? ReadyViewController
        case .play:
            controller = storyboard?.instantiateViewController(
                withIdentifier: GameMessageViewController.storyboardID)
                as? GameMessageViewController
            requestPresentationStyle(.expanded)
        case .score:
            let sController = storyboard?.instantiateViewController(
                withIdentifier: ScoreViewController.storyboardID)
                as? ScoreViewController
            sController?.currentMatch = _currentMatch
            sController?.localID = activeConversation?.localParticipantIdentifier
            controller = sController
            requestPresentationStyle(.expanded)
        }
        
        if let c = controller {
            c.presenter = self
            presentViewController(c)
        } else {
            fatalError("Could not present ViewController")
        }
    }
    
    func sendScore(_ score: Int) {
        var match = _currentMatch ?? RunMatch()
        if let localID = activeConversation?.localParticipantIdentifier {
            match.particpantScores.append(Outcome(participant: localID, score: score))
        } else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = match.queryItems
        
        let layout = MSMessageTemplateLayout()
        guard let image = UIImage(named: "Message Icon") else { fatalError("Could not load Message Icon image asset") }
        layout.image = image
        layout.caption = NSLocalizedString("$\(activeConversation!.localParticipantIdentifier) scored \(score) points in Ragdoll Run", comment: "")
        
        let message = MSMessage(session: _currentSession ?? MSSession())
        message.url = components.url!
        message.layout = layout
        
        activeConversation?.insert(message) { error in
            if let error = error {
                print(error)
            }
        }
        
        // if we just started the match we probably don't need to see the scores, dismiss this window
        if match.particpantScores.count == 1 {
            dismiss()
        }
    }

}
