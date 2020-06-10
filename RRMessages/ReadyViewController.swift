//
//  ReadyViewController.swift
//  RagdollRun
//
//  Created by Jacob Leiken on 6/6/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import Foundation
import UIKit

class ReadyViewController: ViewControllerTransferer {
    
    static let storyboardID = "ReadyViewController"
    
    @IBAction func didTapReady(_: AnyObject) {
        presenter?.markReady()
        presenter?.presentMessagesView(newView: .play)
    }
    
}
