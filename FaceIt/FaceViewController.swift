//
//  ViewController.swift
//  FaceIt
//
//  Created by Zac on 1/23/17.
//  Copyright © 2017 Zac. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController
{
    var expression = FacialExpression(eyes: .open, eyeBrows: .relaxed, mouth: .smile)
    {
        didSet {
            updateUI()
        }
    }
    
    
    // Call updateUI() when init finished
    @IBOutlet weak var faceView: FaceView! {
        
        didSet {
            
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView, action: #selector(FaceView.changeScale(_:))
            ))
            
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.increaseHappiness)
            )
            
            happierSwipeGestureRecognizer.direction = .up
            
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.decreaseHappiness)
            )
            
            sadderSwipeGestureRecognizer.direction = .down
            
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
          
//            faceView.addGestureRecognizer(UIRotationGestureRecognizer(
//                target: self, action: #selector(FaceViewController.changeBrows(_:))
//            ))
            
            updateUI()
        }
    }
    
    func increaseHappiness()
    {
        expression.mouth = expression.mouth.happierMouth()
        
        print("smile")
    }
    
    
    func decreaseHappiness()
    {
        expression.mouth = expression.mouth.sadderMouth()
        
        print("cry")
    }
    
    @IBAction func toggleEyes(_ recognizer: UITapGestureRecognizer)
    {
        if recognizer.state == .ended
        {
            switch expression.eyes
            {
            case .open: expression.eyes = .closed
            
            case .closed: expression.eyes = .open
                
            case .squinting: break
            }
        }
    }
    
    // A dictionary for mouth expression
    private var mouthCurvatures = [FacialExpression.Mouth.frown: -1.0,
                                   .grin: 0.5,
                                   .smile: 1.0,
                                   .smirk: -0.5,
                                   .neutral: 0.0]
    
    private var eyeBrowTilts = [FacialExpression.EyeBrows.relaxed: 0.5, .furrowed: -0.5, .normal: 0.0]
    
    private func updateUI()
    {
        switch expression.eyes
        {
        case .open: faceView.eyesOpen = true
        case . closed: faceView.eyesOpen = false
        case .squinting: faceView.eyesOpen = false
        }
        // Because dictionary look up is Optional type, but mouthCurvature is Double
        faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0 // default 0
        
        faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
    }
}
