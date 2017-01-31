//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Zac on 1/30/17.
//  Copyright © 2017 Zac. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController
{
    private let emotionalFaces: Dictionary<String, FacialExpression> = [
        "angry": FacialExpression(eyes: .closed, eyeBrows: .furrowed, mouth: .frown),
        "happy": FacialExpression(eyes: .open, eyeBrows: .normal, mouth: .smile),
        "worried": FacialExpression(eyes: .open, eyeBrows: .relaxed, mouth: .smirk),
        "mischievious": FacialExpression(eyes: .open, eyeBrows: .furrowed, mouth: .grin)
    ]
    
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var destinationvc = segue.destination
        
        if let navcon = destinationvc as? UINavigationController
        {
            destinationvc = navcon.visibleViewController ?? destinationvc
        }
        if let facevc = destinationvc as? FaceViewController
        {
            if let identifier = segue.identifier
            {
                if let expression = emotionalFaces[identifier]
                {
                    facevc.expression = expression
                    
                    if let sendingButton = sender as? UIButton
                    {
                        facevc.navigationItem.title = sendingButton.currentTitle
                    }
                }
            }
        }
        
    }
    

}
