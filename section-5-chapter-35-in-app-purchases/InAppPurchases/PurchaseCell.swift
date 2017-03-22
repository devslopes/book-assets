//
//  PurchaseCell.swift
//  InAppPurchases
//
//  Created by Jacob Luetzow on 7/24/16.
//  Copyright © 2016 Devslopes. All rights reserved.
//

import UIKit

class PurchaseCell: UICollectionViewCell {
    
    @IBOutlet weak var purchaseImage: UIImageView!
    @IBOutlet weak var purchaseLbl: UILabel!
    
    func configureCell(imageName: String, price: String){
        switch imageName {
        case "com.devslopes.InAppPurchases.tier1":
            purchaseImage.image = UIImage(named: "Arcade-1")
            purchaseLbl.text = price
            break
        case "com.devslopes.InAppPurchases.tier2":
            purchaseImage.image = UIImage(named: "Arcade-2")
            purchaseLbl.text = price
            break
        case "com.devslopes.InAppPurchases.tier3":
            purchaseImage.image = UIImage(named: "Arcade-3")
            purchaseLbl.text = price
            break
        case "com.devslopes.InAppPurchases.tier4":
            purchaseImage.image = UIImage(named: "Arcade-4")
            purchaseLbl.text = price
            break
        case "com.devslopes.InAppPurchases.tier5":
            purchaseImage.image = UIImage(named: "Bear-1")
            purchaseLbl.text = price
            break
        default:
            break
        }
    }
}
