//
//  ViewController.swift
//  InAppPurchases
//
//  Created by Jacob Luetzow on 7/24/16.
//  Copyright © 2016 Devslopes. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var products = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        requestProducts()
    }
    
    func requestProducts() {
        let ids: Set<String> = ["com.devslopes.InAppPurchases.tier1","com.devslopes.InAppPurchases.tier2","com.devslopes.InAppPurchases.tier3","com.devslopes.InAppPurchases.tier4","com.devslopes.InAppPurchases.tier5"]
        let productsRequest = SKProductsRequest(productIdentifiers: ids)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Products ready: \(response.products.count)")
        print("Products not ready: \(response.invalidProductIdentifiers.count)")
        products = response.products
        collectionView.reloadData()
        for product in response.products {
            print(product.productIdentifier)
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("purchased")
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .failed:
                print("failed")
                let errorMsg: String! = transaction.error?.localizedDescription
                showErrorAlert(title: "Oops! Something went wrong.", msg: "Unable to make purchase.  Reason: \(errorMsg).")
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .restored:
                print("restored")
                showErrorAlert(title: "Purchases Restored.", msg: "Your purchases have been restored.")
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .purchasing:
                print("purchasing")
                break
            case .deferred:
                print("deferred")
                break
            }
        }
    }
    
    @IBAction func restoreBtnPressed(_ sender: AnyObject) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellPrice = ""
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "purchaseCell", for: indexPath) as? PurchaseCell {
            let product = products[indexPath.row]
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.currency
            formatter.locale = product.priceLocale
            if let price = formatter.string(from: product.price){
                cellPrice = "\(price)"
            }

            cell.configureCell(imageName: products[indexPath.row].productIdentifier, price: cellPrice)
            return cell
        }else {
        return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //This is so the cells look good on any screen size
        return CGSize(width: self.collectionView.bounds.size.width/2 - 20, height: 160)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SKPaymentQueue.default().add(self)
        let payment = SKMutablePayment(product: products[indexPath.row])
        payment.simulatesAskToBuyInSandbox = true 
        SKPaymentQueue.default().add(payment)
    }

    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion:nil)
    }
  
}

