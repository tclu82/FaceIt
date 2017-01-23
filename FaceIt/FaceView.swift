//
//  FaceView.swift
//  FaceIt
//
//  Created by Zac on 1/23/17.
//  Copyright © 2017 Zac. All rights reserved.
//

import UIKit

class FaceView: UIView {
    
    var scale: CGFloat = 0.90
    
    var mouthCurvature: Double = 1.0 // 1 full smile, -1 full frown
    
    var pathLineWidth: CGFloat = 5.0
    
    private var skullRadius: CGFloat
    {
        return min(bounds.size.width, bounds.size.height) / 2
    }
    private var skullCenter: CGPoint
    {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    // Define constant in Swift
    private struct Ratios
    {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        
        static let SkullRadiusToEyeRadius: CGFloat = 10
        
        static let SkullRadiusToMouthWidth: CGFloat = 1
        
        static let SkullRadiusToMouthHeight: CGFloat = 3
    
        static let SkullRadiusToMouthOffset: CGFloat = 3
    }
    
    private enum Eye
    {
        case Left
        
        case Right
    }
    // withRadius(external name) radius(internal name)
    private func pathForCircelCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2 * M_PI),
            clockwise: false)
    
        path.lineWidth = pathLineWidth
        
        return path
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint
    {
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        
        var eyeCenter = skullCenter
        
        eyeCenter.y -= eyeOffset
        
        switch eye
        {
            case .Left: eyeCenter.x -= eyeOffset
            
            case .Right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    
    private func pathForEye(eye: Eye) -> UIBezierPath
    {
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        
        let eyeCenter = getEyeCenter(eye: eye)
        
        return pathForCircelCenteredAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)
    }
    
    private func pathForMouth() -> UIBezierPath
    {
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        
        let mouthOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        
        let mouthRect = CGRect(
            x: skullCenter.x - mouthWidth / 2,
            y: skullCenter.y + mouthOffset,
            width: mouthWidth,
            height: mouthHeight)
        
        //let mouthCurvature: Double = 1.0 // 1 full smile, -1 full frown
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        
        path.move(to: start)
        
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        
        path.lineWidth = pathLineWidth
        
        return path
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect)
    {   // bounds is the actual view's bounds
//        let skullRadius = min(bounds.size.width, bounds.size.height) / 2
        
        //let skullCenter = convert(center, from: superview)
        
//        let skullCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        // Couter clockwise
        //let skull = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0.0, endAngle: CGFloat(2 * M_PI), clockwise: false)
        UIColor.blue.set()
        
        pathForCircelCenteredAtPoint(midPoint: skullCenter, withRadius: skullRadius).stroke()
        
        pathForEye(eye: .Left).stroke()
        
        pathForEye(eye: .Right).stroke()
        
        pathForMouth().stroke()
    }
}
