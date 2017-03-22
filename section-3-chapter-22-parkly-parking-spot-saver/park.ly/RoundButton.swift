//
//  RoundButton.swift
//  park.ly
//
//  Created by Caleb Stultz on 1/18/17.
//  Copyright © 2017 Caleb Stultz. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.shadowRadius = 20
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.black.cgColor
    }

}
