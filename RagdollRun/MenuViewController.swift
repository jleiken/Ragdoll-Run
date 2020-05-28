//
//  MenuViewController.swift
//  RegularMaria
//
//  Created by Jacob Leiken on 5/20/20.
//  Copyright © 2020 Jacob Leiken. All rights reserved.
//

import UIKit

class MenuViewController : UIViewController {
    @IBAction func playBut(_ sender: UIButton) {
        //self.present(GameViewController(), animated: true, completion: nil)
        // I DONT KNOW WHY I NEED THIS STUB BUT NOT THE FUNCTION CALL
    }
    
}

class PlaySegue : UIStoryboardSegue {
    override func perform() {
        source.present(destination, animated: true)
    }
}
