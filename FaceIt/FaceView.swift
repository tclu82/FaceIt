//
//  FaceView.swift
//  FaceIt
//
//  Created by Zac on 1/23/17.
//  Copyright © 2017 Zac. All rights reserved.
//

import UIKit

// Now can be adjustable on storyboard
@IBDesignable

class FaceView: UIView {
    
    // Now can be adjustable on storyboard / FaceView
    // CGFloat needs to be type, otherwise it won't show on storyboad
    @IBInspectable
    var scale: CGFloat = 0.90 { didSet { setNeedsDisplay() } }

    // 1 full smile, -1 full frown
    @IBInspectable
    var mouthCurvature: Double = 1.0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var eyesOpen: Bool = false { didSet { setNeedsDisplay() } }
    // -1 full furrow, 1 fully relaxed
    @IBInspectable
    var eyeBrowTilt: Double = -0.5 { didSet { setNeedsDisplay() } }

    @IBInspectable
    var pathLineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }

    @IBInspectable
    var color: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }

    
    // Define constant in Swift
    private struct Ratios
    {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        
        static let SkullRadiusToEyeRadius: CGFloat = 10
        
        static let SkullRadiusToMouthWidth: CGFloat = 1
        
        static let SkullRadiusToMouthHeight: CGFloat = 3
    
        static let SkullRadiusToMouthOffset: CGFloat = 3
        
        static let SkullRadiusToBrowOffset: CGFloat = 5
    }
    
    
    /// For controller change scale using Pinch gesture
    ///
    /// - Parameter recognizer: <#recognizer description#>
    func changeScale(_ recognizer: UIPinchGestureRecognizer)
    {
        switch recognizer.state
        {
        case .changed, .ended:
            
            scale *= recognizer.scale
            
            recognizer.scale = 1.0
        
            print("scale changed")
            
        default:
            
            break
        }
    }
    
    // MARK: Private implementation
    
    fileprivate var skullRadius: CGFloat
    {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    fileprivate var skullCenter: CGPoint
    {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    /// Enum for eyes
    ///
    /// - Left: <#Left description#>
    /// - Right: Right description
    private enum Eye
    {
        case Left
        
        case Right
    }
    
    /// It calculate the path for circle center point
    ///
    /// withRadius(external name) radius(internal name)
    ///
    /// - Parameters:
    ///   - midPoint: midPoint description
    ///   - radius: radius description
    /// - Returns: <#return value description#>
    private func pathForCircelCenteredAtPoint(_ midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath
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
    
    /// Get the Eye center
    ///
    /// - Parameter eye: eye description
    /// - Returns: return value description
    private func getEyeCenter(_ eye: Eye) -> CGPoint
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
    
    /// Draw the path for eye
    ///
    /// - Parameter eye: eye description
    /// - Returns: return value description
    private func pathForEye(_ eye: Eye) -> UIBezierPath
    {
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        
        let eyeCenter = getEyeCenter(eye)
        
        if eyesOpen
        {
            return pathForCircelCenteredAtPoint(eyeCenter, withRadius: eyeRadius)
        }
        else
        {
            let path = UIBezierPath()
            
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            
            path.lineWidth = pathLineWidth
            
            return path
        }
    }
    
    /// Draw the path of mouth
    ///
    /// - Returns: return value description
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
    
    private func pathForBorw(_ eye: Eye) -> UIBezierPath
    {
        var tilt = eyeBrowTilt
        
        switch eye
        {
        case .Left: tilt *= -1.0
            
        case .Right: break
        }
        var browCenter = getEyeCenter(eye)
        
        browCenter.y -= skullRadius / Ratios.SkullRadiusToBrowOffset
        
        let eyeRadious = skullRadius / Ratios.SkullRadiusToEyeRadius
        
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadious / 2
        
        let browStart = CGPoint(x: browCenter.x - eyeRadious, y: browCenter.y - tiltOffset)
        
        let browEnd = CGPoint(x: browCenter.x + eyeRadious, y: browCenter.y + tiltOffset)
        
        let path = UIBezierPath()
        
        path.move(to: browStart)
        
        path.addLine(to: browEnd)
        
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
        color.set()
        
        pathForCircelCenteredAtPoint(skullCenter, withRadius: skullRadius).stroke()
        
        pathForEye(.Left).stroke()
        
        pathForEye(.Right).stroke()
        
        pathForMouth().stroke()
        
        pathForBorw(.Left).stroke()
        
        pathForBorw(.Right).stroke()
    }
}
