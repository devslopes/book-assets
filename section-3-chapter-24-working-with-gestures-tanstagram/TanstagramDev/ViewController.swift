//
//  ViewController.swift
//  TanstagramDev
//
//  Created by Pearson Basham on 10/25/16.
//  Copyright © 2016 Devslopes. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var smallTriangleOne: UIImageView!
    @IBOutlet weak var smallTriangleTwo: UIImageView!
    @IBOutlet weak var bigTriangleOne: UIImageView!
    @IBOutlet weak var bigTriangleTwo: UIImageView!
    @IBOutlet weak var squareImg: UIImageView!
    @IBOutlet weak var parallelogram: UIImageView!
    @IBOutlet weak var midTriangle: UIImageView!
    @IBOutlet weak var saveToPhotos: UIImageView!
    @IBOutlet weak var containter: UIView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
    
        createPinchGesture()
        createPanGesture()
        createRotationGesture()
    }
    
    
    @IBAction func saveToPhotosTapGesture(_ sender: UITapGestureRecognizer) {
        renderContainter()
    }
    
    func renderContainter() {
        let renderer = UIGraphicsImageRenderer(size: containter.bounds.size)
        let image = renderer.image { (ctx) in
            containter.drawHierarchy(in: containter.bounds, afterScreenUpdates: true)
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(ViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func pinchGesture(imageView: UIImageView) -> UIPinchGestureRecognizer {
        return UIPinchGestureRecognizer(target: self, action: #selector(ViewController.handlePinch))
    }
    
    func panGesture(imageView : UIImageView) -> UIPanGestureRecognizer {
        return UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan))
    }
    
    func rotateGesture(imageView: UIImageView) -> UIRotationGestureRecognizer {
        return UIRotationGestureRecognizer(target: self, action: #selector(ViewController.handleRotation))
    }
    
    func createPinchGesture() {
        let smallTriangleOnePinchGesture = pinchGesture(imageView: smallTriangleOne)
        let smallTriangleTwoPinchGesture = pinchGesture(imageView: smallTriangleTwo)
        let bigTriangleOnePinchGesture = pinchGesture(imageView: bigTriangleOne)
        let bigTriangleTwoPinchGesture = pinchGesture(imageView: bigTriangleTwo)
        let squareImgPinchGesture = pinchGesture(imageView: squareImg)
        let parallelogramPinchGesture = pinchGesture(imageView: parallelogram)
        let midTrianglePinchGesture = pinchGesture(imageView: parallelogram)
        
        smallTriangleOne.addGestureRecognizer(smallTriangleOnePinchGesture)
        smallTriangleTwo.addGestureRecognizer(smallTriangleTwoPinchGesture)
        bigTriangleOne.addGestureRecognizer(bigTriangleOnePinchGesture)
        bigTriangleTwo.addGestureRecognizer(bigTriangleTwoPinchGesture)
        squareImg.addGestureRecognizer(squareImgPinchGesture)
        parallelogram.addGestureRecognizer(parallelogramPinchGesture)
        midTriangle.addGestureRecognizer(midTrianglePinchGesture)
        
    }
    
    func createPanGesture() {
        
        let smallTriangleOnePanGesture = panGesture(imageView: smallTriangleOne)
        let smallTriangleTwoPanGesture = panGesture(imageView: smallTriangleTwo)
        let bigTriangleOnePanGesture = panGesture(imageView: bigTriangleOne)
        let bigTriangleTwoPanGesture = panGesture(imageView: bigTriangleTwo)
        let squareImgPanGesture = panGesture(imageView: squareImg)
        let parallelogramPanGesture = panGesture(imageView: parallelogram)
        let midTrianglePanGesture = panGesture(imageView: midTriangle)
        
        smallTriangleOne.addGestureRecognizer(smallTriangleOnePanGesture)
        smallTriangleTwo.addGestureRecognizer(smallTriangleTwoPanGesture)
        bigTriangleOne.addGestureRecognizer(bigTriangleOnePanGesture)
        bigTriangleTwo.addGestureRecognizer(bigTriangleTwoPanGesture)
        squareImg.addGestureRecognizer(squareImgPanGesture)
        parallelogram.addGestureRecognizer(parallelogramPanGesture)
        midTriangle.addGestureRecognizer(midTrianglePanGesture)
        
    }
    
    func createRotationGesture() {
        
        let smallTriangleOneRotateGesture = rotateGesture(imageView: smallTriangleOne)
        let smallTriangleTwoRotateGesture = rotateGesture(imageView: smallTriangleTwo)
        let bigTriangleOneRotateGesture = rotateGesture(imageView: bigTriangleOne)
        let bigTriangleTwoRotateGesture = rotateGesture(imageView: bigTriangleTwo)
        let squareImgRotateGesture = rotateGesture(imageView: squareImg)
        let parallelogramRotateGesture = rotateGesture(imageView: parallelogram)
        let midTriangleRotateGesture = rotateGesture(imageView: midTriangle)
        
        smallTriangleOne.addGestureRecognizer(smallTriangleOneRotateGesture)
        smallTriangleTwo.addGestureRecognizer(smallTriangleTwoRotateGesture)
        bigTriangleOne.addGestureRecognizer(bigTriangleOneRotateGesture)
        bigTriangleTwo.addGestureRecognizer(bigTriangleTwoRotateGesture)
        squareImg.addGestureRecognizer(squareImgRotateGesture)
        parallelogram.addGestureRecognizer(parallelogramRotateGesture)
        midTriangle.addGestureRecognizer(midTriangleRotateGesture)

    }
    
    func handlePinch(_ sender: UIPinchGestureRecognizer) {
        sender.view?.transform = (sender.view?.transform)!.scaledBy(x: sender.scale, y: sender.scale)
        
        sender.scale = 1
    }
    
    func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func handleRotation(_ sender: UIRotationGestureRecognizer) {
        sender.view?.transform = (sender.view?.transform)!.rotated(by: sender.rotation)
        sender.rotation = 0
    }
   
}

