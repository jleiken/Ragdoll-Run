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
    
    func markReady()
    
    func presentMessagesView(newView: MessagesView, currentMatch: RunMatch?)
    
}

class ViewControllerTransferer: UIViewController {
    
    var _presenter: MessagesViewPresenter?
    var presenter: MessagesViewPresenter? {
        get { return _presenter }
        set { _presenter = newValue }
    }
    
    var _currentMatch: RunMatch?
    var currentMatch: RunMatch? {
        get { return _currentMatch }
        set { _currentMatch = newValue }
    }
    
}
