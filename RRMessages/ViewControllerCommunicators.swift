//
//  ViewControllerCommunicators.swift
//  Ragdoll Run
//
//  Created by Jacob Leiken on 6/9/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import Foundation
import UIKit

enum MessagesView {
    case ready
    case play
    case score
}

protocol MessagesViewPresenter {
    
    /// mark the user as having pressed a ready button
    func markReady(_ ready: Bool)
    
    /// clears the current match so that a new one can be started
    func clearConversation()
    
    /// send a score message in the current conversation
    func sendScore(_ score: Int)
    
    /// present a new MessagesView
    func presentMessagesView(newView: MessagesView)
    
}

class ViewControllerTransferer: UIViewController {
    
    var _presenter: MessagesViewPresenter?
    var presenter: MessagesViewPresenter? {
        get { return _presenter }
        set { _presenter = newValue }
    }
    
}
