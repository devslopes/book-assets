//
//  ViewController.swift
//  HelloooooWorld
//
//  Created by Pearson Basham on 10/30/16.
//  Copyright © 2016 Devslopes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleImage: UIImageView!
    
    @IBOutlet weak var welcomeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showImages(_ sender: Any) {
        backgroundImage.isHidden = false
        titleImage.isHidden = false
        welcomeBtn.isHidden = true
    }
    
}

