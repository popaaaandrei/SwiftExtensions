//
//  Extensions.swift
//
//  Created by Andrei on 28/03/15.
//  Copyright (c) 2015 Andrei. All rights reserved.
//

import UIKit
import ObjectiveC
import MessageUI
import CoreImage
import CoreGraphics



// ============================================================================
// MARK: Foundation
// ============================================================================
extension Bool {
    mutating func toggle() {
        self = !self
    }
}


extension String {
    
    func sizeOfString(constrainedToWidth width: CGFloat?, height: CGFloat?, font: UIFont) -> CGSize {
        
        var constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        if let width = width {
            constraintRect.width = width
        }
        if let height = height {
            constraintRect.height = height
        }
        
        return NSString(string: self)
            .boundingRect(with: constraintRect,
                                  options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                  attributes: [NSFontAttributeName: font],
                                  context: nil).size
    }
    
    func widthOfString(font: UIFont) -> CGFloat {
        return self.sizeOfString(constrainedToWidth: UIScreen.main.bounds.size.width, height: 100, font: font).width
    }
    
    // return calculated maximum font size that fits a box
    func calculateMaximumFontSize(box: CGSize, boxPercent: CGFloat, fontName: String) -> CGFloat {
        
        // start values
        var fontSize : CGFloat = 7
        var boundingSize = CGSize.zero
        let restrictedBox = CGSize(width: box.width * boxPercent, height: box.height * boxPercent)
        
        // if we have a valid string
        guard self.characters.count > 0 else {
            return fontSize
        }
        
        // check whether the font exists, else return minimum size
        guard let _ = UIFont(name: fontName, size: fontSize) else {
            return fontSize
        }
        
        while restrictedBox.height > boundingSize.height  &&
            restrictedBox.width > boundingSize.width  {
                
                fontSize += 1
                let textFontSize = fontSize + 1
                
                let font = UIFont(name: fontName, size: textFontSize)!
                
                let attributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.black]
                
                boundingSize = NSAttributedString(string: self, attributes: attributes).boundingRect(with: restrictedBox, options: NSStringDrawingOptions.usesFontLeading, context: nil).size
        }
        
        return fontSize
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    func trim(charactersInString: String) -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: charactersInString))
    }
}




// ============================================================================
// MARK: Basic Data types
// MARK: UIFontDescriptor + UIFont
// ============================================================================
var fontSizeTable : [UIFontTextStyle: [UIContentSizeCategory:CGFloat]] = {
    [
        UIFontTextStyle.headline: [
            UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 26,
            UIContentSizeCategory.accessibilityExtraExtraLarge: 25,
            UIContentSizeCategory.accessibilityExtraLarge: 24,
            UIContentSizeCategory.accessibilityLarge: 24,
            UIContentSizeCategory.accessibilityMedium: 23,
            UIContentSizeCategory.extraExtraExtraLarge: 23,
            UIContentSizeCategory.extraExtraLarge: 22,
            UIContentSizeCategory.extraLarge: 21,
            UIContentSizeCategory.large: 20,
            UIContentSizeCategory.medium: 19,
            UIContentSizeCategory.small: 18,
            UIContentSizeCategory.extraSmall: 17
        ],
        UIFontTextStyle.subheadline: [
            UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 24,
            UIContentSizeCategory.accessibilityExtraExtraLarge: 23,
            UIContentSizeCategory.accessibilityExtraLarge: 22,
            UIContentSizeCategory.accessibilityLarge: 22,
            UIContentSizeCategory.accessibilityMedium: 21,
            UIContentSizeCategory.extraExtraExtraLarge: 21,
            UIContentSizeCategory.extraExtraLarge: 20,
            UIContentSizeCategory.extraLarge: 19,
            UIContentSizeCategory.large: 18,
            UIContentSizeCategory.medium: 17,
            UIContentSizeCategory.small: 16,
            UIContentSizeCategory.extraSmall: 15
        ],
        UIFontTextStyle.body: [
            UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 21,
            UIContentSizeCategory.accessibilityExtraExtraLarge: 20,
            UIContentSizeCategory.accessibilityExtraLarge: 19,
            UIContentSizeCategory.accessibilityLarge: 19,
            UIContentSizeCategory.accessibilityMedium: 18,
            UIContentSizeCategory.extraExtraExtraLarge: 18,
            UIContentSizeCategory.extraExtraLarge: 17,
            UIContentSizeCategory.extraLarge: 16,
            UIContentSizeCategory.large: 15,
            UIContentSizeCategory.medium: 14,
            UIContentSizeCategory.small: 13,
            UIContentSizeCategory.extraSmall: 12
        ],
        UIFontTextStyle.caption1: [
            UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 19,
            UIContentSizeCategory.accessibilityExtraExtraLarge: 18,
            UIContentSizeCategory.accessibilityExtraLarge: 17,
            UIContentSizeCategory.accessibilityLarge: 17,
            UIContentSizeCategory.accessibilityMedium: 16,
            UIContentSizeCategory.extraExtraExtraLarge: 16,
            UIContentSizeCategory.extraExtraLarge: 16,
            UIContentSizeCategory.extraLarge: 15,
            UIContentSizeCategory.large: 14,
            UIContentSizeCategory.medium: 13,
            UIContentSizeCategory.small: 12,
            UIContentSizeCategory.extraSmall: 12
        ],
        UIFontTextStyle.caption2: [
            UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 18,
            UIContentSizeCategory.accessibilityExtraExtraLarge: 17,
            UIContentSizeCategory.accessibilityExtraLarge: 16,
            UIContentSizeCategory.accessibilityLarge: 16,
            UIContentSizeCategory.accessibilityMedium: 15,
            UIContentSizeCategory.extraExtraExtraLarge: 15,
            UIContentSizeCategory.extraExtraLarge: 14,
            UIContentSizeCategory.extraLarge: 14,
            UIContentSizeCategory.large: 13,
            UIContentSizeCategory.medium: 12,
            UIContentSizeCategory.small: 12,
            UIContentSizeCategory.extraSmall: 11
        ],
        UIFontTextStyle.footnote: [
            UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 16,
            UIContentSizeCategory.accessibilityExtraExtraLarge: 15,
            UIContentSizeCategory.accessibilityExtraLarge: 14,
            UIContentSizeCategory.accessibilityLarge: 14,
            UIContentSizeCategory.accessibilityMedium: 13,
            UIContentSizeCategory.extraExtraExtraLarge: 13,
            UIContentSizeCategory.extraExtraLarge: 12,
            UIContentSizeCategory.extraLarge: 12,
            UIContentSizeCategory.large: 11,
            UIContentSizeCategory.medium: 11,
            UIContentSizeCategory.small: 10,
            UIContentSizeCategory.extraSmall: 10
        ]
    ]
}()


extension UIFontDescriptor {
    
    class func preferredFont(fontName: String, dynamicTextStyle: UIFontTextStyle) -> UIFontDescriptor {
        
        let contentSize = UIApplication.shared.preferredContentSizeCategory
        
        let style = fontSizeTable[dynamicTextStyle]!
        
        return UIFontDescriptor(name: fontName, size: style[contentSize]!)
    }
    
}

extension UIFont {
    
    class func listAllAvailableFonts() {
    
        for family in UIFont.familyNames
        {
            print("\(family)")
            for names in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
        
    }

}



// ============================================================================
// MARK: UIColor
// ============================================================================
extension UIColor {
    
    func darkerColorForColor(factor: CGFloat) -> UIColor {
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(
                red: max(r - factor, 0.0),
                green: max(g - factor, 0.0),
                blue: max(b - factor, 0.0),
                alpha: a)
        }
        
        return UIColor()
    }
    
    func lighterColorForColor(factor: CGFloat) -> UIColor {
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(
                red: min(r + factor, 1.0),
                green: min(g + factor, 1.0),
                blue: min(b + factor, 1.0),
                alpha: a)
        }
        
        return UIColor()
    }
    
    // let red = UIColor(hex: "#ff0000")
    convenience init?(hex: String)
    {
        guard hex.hasPrefix("#") else {
            print("invalid rgb string, missing '#' as prefix")
            return nil
        }
        
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        let alpha: CGFloat = 1.0
        
        let index   = hex.index(hex.startIndex, offsetBy: 1)
        let hex     = hex.substring(from: index)
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        
        if scanner.scanHexInt64(&hexValue) {
            red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
            green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
            blue  = CGFloat(hexValue & 0x0000FF) / 255.0
        } else {
            print("scan hex error, your string should be a hex string of 7 chars. ie: #ebb100")
            return nil
        }
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    class func adjustValue(color: UIColor, percentage: CGFloat = 1.5) -> UIColor
    {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        return UIColor(hue: h, saturation: s, brightness: (b * percentage), alpha: a)
    }
    
    class func randomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
}

// ============================================================================
// MARK: UIBezierPath
// ============================================================================
func pointFrom(angle: CGFloat, radius: CGFloat, offset: CGPoint) -> CGPoint {
    return CGPoint(x: radius * cos(angle) + offset.x, y: radius * sin(angle) + offset.y)
}

extension UIBezierPath {
    
    class func generateStar(size: CGSize = CGSize(width: 128, height: 128), pointsOnStar: Int = 5) -> UIBezierPath {
        let path = UIBezierPath()
        
        guard pointsOnStar > 3 else {
            return path
        }
        
        let starExtrusion : CGFloat = 30.0
        
        let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        
        var angle:CGFloat = -CGFloat(M_PI / 2.0)
        let angleIncrement = CGFloat(M_PI * 2.0 / Double(pointsOnStar))
        let radius = size.width / 2.0
        
        var firstPoint = true
        
        for _ in 1...pointsOnStar {
            
            let point = pointFrom(angle: angle, radius: radius, offset: center)
            let nextPoint = pointFrom(angle: angle + angleIncrement, radius: radius, offset: center)
            let midPoint = pointFrom(angle: angle + angleIncrement / 2.0, radius: starExtrusion, offset: center)
            
            if firstPoint {
                firstPoint = false
                path.move(to: point)
            }
            
            path.addLine(to: midPoint)
            path.addLine(to: nextPoint)
            
            angle += angleIncrement
        }
        
        path.close()
        
        return path
    }
    
    class func generateStarPoints() -> UIBezierPath {
    
        let starPath = UIBezierPath()
        starPath.move(to: CGPoint(x: 64, y: 0))
        starPath.addLine(to: CGPoint(x: 82.7, y: 38.26))
        starPath.addLine(to: CGPoint(x: 124.87, y: 44.22))
        starPath.addLine(to: CGPoint(x: 94.27, y: 73.83))
        starPath.addLine(to: CGPoint(x: 101.62, y: 115.78))
        starPath.addLine(to: CGPoint(x: 64, y: 95.82))
        starPath.addLine(to: CGPoint(x: 26.38, y: 115.78))
        starPath.addLine(to: CGPoint(x: 33.73, y: 73.83))
        starPath.addLine(to: CGPoint(x: 3.13, y: 44.22))
        starPath.addLine(to: CGPoint(x: 45.3, y: 38.26))
        starPath.close()
    
        return starPath
    }
    
    class func generateLeftArrow(size: CGSize, lineWidth: CGFloat) -> UIBezierPath {
    
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: size.width - lineWidth, y: lineWidth))
        bezierPath.addLine(to: CGPoint(x: lineWidth, y: size.height / 2))
        bezierPath.addLine(to: CGPoint(x: size.width - lineWidth, y: size.height - lineWidth))
        bezierPath.lineWidth = lineWidth
        bezierPath.lineCapStyle = .round
        bezierPath.lineJoinStyle = .round
        
        return bezierPath
    }
    
    class func generateRightArrow(size: CGSize, lineWidth: CGFloat) -> UIBezierPath {
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: lineWidth, y: lineWidth))
        bezierPath.addLine(to: CGPoint(x: size.width - lineWidth, y: size.height / 2))
        bezierPath.addLine(to: CGPoint(x: lineWidth, y: size.height - lineWidth))
        bezierPath.lineWidth = lineWidth
        bezierPath.lineCapStyle = .round
        bezierPath.lineJoinStyle = .round
                
        return bezierPath
    }
}

// ============================================================================
// MARK: CAShapeLayer
// ============================================================================

// helper method to convert degrees to radians
func degree2radian(arc: CGFloat) -> CGFloat {
    return ( CGFloat(M_PI) * arc ) / 180
}

extension CAShapeLayer {
    func setupRotationWithPath(duration: Double, clockwise: Bool = true) {
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.toValue = clockwise ? degree2radian(arc: 360) : degree2radian(arc: -360)
        rotateAnimation.duration = duration
        rotateAnimation.isCumulative = true
        rotateAnimation.repeatCount = HUGE
        // rotateAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        rotateAnimation.fillMode = kCAFillModeForwards
        self.add(rotateAnimation, forKey: rotateAnimation.keyPath)
    }
}

// ============================================================================
// MARK: UIImage
// Ignacio Nieto Carvajal - digitalleaves.com
// fabb - https://gist.github.com/fabb
// ============================================================================
extension UIImage {
    
    func alpha(value: CGFloat) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        guard let ctx = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage else {
            return nil
        }
        
        
        let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        ctx.scaleBy(x: 1, y: -1)
        ctx.translateBy(x: 0, y: -area.size.height)
        ctx.setBlendMode(CGBlendMode.multiply)
        ctx.setAlpha(value)
        ctx.draw(cgImage, in: area)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
    // colorize image with given tint color
    // this is similar to Photoshop's "Color" layer blend mode
    // this is perfect for non-greyscale source images, and images that have both highlights and shadows that should be preserved
    // white will stay white and black will stay black as the lightness of the image is preserved
    func tint(tintColor: UIColor) -> UIImage? {
        
        return modifiedImage { context, rect in
            // draw black background - workaround to preserve color of partially transparent pixels
            context.setBlendMode(.normal)
            UIColor.black.setFill()
            context.fill(rect)
            
            // draw original image
            context.setBlendMode(.normal)
            context.draw(self.cgImage!, in: rect)
            
            // tint image (loosing alpha) - the luminosity of the original image is preserved
            context.setBlendMode(.color)
            tintColor.setFill()
            context.fill(rect)
            
            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(self.cgImage!, in: rect)
        }
    }
    
    // fills the alpha channel of the source image with the given color
    // any color information except to the alpha channel will be ignored
    func fillAlpha(fillColor: UIColor) -> UIImage? {
        
        return modifiedImage { context, rect in
            // draw tint color
            context.setBlendMode(.normal)
            fillColor.setFill()
            context.fill(rect)
            
            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(self.cgImage!, in: rect)
        }
    }
    
    private func modifiedImage(draw: (CGContext, CGRect) -> ()) -> UIImage? {
        
        // using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        assert(context != nil)
        
        // correctly rotate image
        context.translateBy(x: 0, y: size.height);
        context.scaleBy(x: 1.0, y: -1.0);
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        draw(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    
    func imageWithColor(tintColor: UIColor) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context.fill(rect)
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    class func imageWithColor(color: UIColor) -> UIImage? {
        
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        color.setFill()
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    /*
    class func shapeImageWithBezierPath(bezierPath: UIBezierPath, fillColor: UIColor?, strokeColor: UIColor?, strokeWidth: CGFloat = 0.0) -> UIImage {
        //: 1. Normalize bezier path. We will apply a transform to our bezier path to ensure that it's placed at the coordinate axis. Then we can get its size.
        bezierPath.applyTransform(CGAffineTransformMakeTranslation(-bezierPath.bounds.origin.x, -bezierPath.bounds.origin.y))
        let size = CGSizeMake(bezierPath.bounds.size.width, bezierPath.bounds.size.height)
        
        //: 2. Initialize an image context with our bezier path normalized shape and save current context
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        //: 3. Set path
        CGContextAddPath(context, bezierPath.CGPath)
        
        //: 4. Set parameters and draw
        if let strokeColor = strokeColor {
            strokeColor.setStroke()
            CGContextSetLineWidth(context, strokeWidth)
        }
        else { UIColor.clearColor().setStroke() }
        fillColor?.setFill()
        
        CGContextDrawPath(context, .FillStroke)
        //: 5. Get the image from the current image context
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //: 6. Restore context and close everything
        CGContextRestoreGState(context)
        UIGraphicsEndImageContext()
        //: Return image
        return image
    }
    */
    
    
    class func imageWithBezierPathFill(size: CGSize, bezierPath: UIBezierPath, color: UIColor) -> UIImage? {
        
        guard size.width > 0 && size.height > 0 else {
            return nil
        }
        
        // create the graphics context
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.saveGState()
        
        //// Bezier Drawing
        color.setFill()
        bezierPath.lineCapStyle = CGLineCap.round
        bezierPath.fill()
        
        context.restoreGState()
        // save the image from the implicit context into an image
        let result = UIGraphicsGetImageFromCurrentImageContext()
        // cleanup
        UIGraphicsEndImageContext()
        
        return result
    }
    
    class func imageWithBezierPathStroke(size: CGSize, bezierPath: UIBezierPath, color: UIColor) -> UIImage? {
        
        guard size.width > 0 && size.height > 0 else {
            return nil
        }
        
        // create the graphics context
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.saveGState()
        
        //// Bezier Drawing
        color.setStroke()
        bezierPath.lineCapStyle = CGLineCap.round
        bezierPath.stroke()
        
        context.restoreGState()
        // save the image from the implicit context into an image
        let result = UIGraphicsGetImageFromCurrentImageContext()
        // cleanup
        UIGraphicsEndImageContext()
        
        return result
    }
    
    func resizeTo(newSize:CGSize) -> UIImage? {
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(newSize, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    func getAspectFitRect(origin src:CGSize, destination dst:CGSize) -> CGSize {
        var result = CGSize.zero
        var scaleRatio = CGPoint()
        
        if (dst.width != 0) {scaleRatio.x = src.width / dst.width}
        if (dst.height != 0) {scaleRatio.y = src.height / dst.height}
        let scaleFactor = max(scaleRatio.x, scaleRatio.y)
        
        result.width  = scaleRatio.x * dst.width / scaleFactor
        result.height = scaleRatio.y * dst.height / scaleFactor
        return result
    }
    
    func resizeImage(image:UIImage, size:CGSize) -> UIImage? {
        let scale     = UIScreen.main.scale
        let size      = scale > 1 ? CGSize(width: size.width/scale, height: size.height/scale) : size
        let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.width)
        
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        image.draw(in: imageRect)
        let scaled = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaled
    }
    
    func resizeImageWithAspectFit(size: CGSize) -> UIImage? {
        let aspectFitSize = self.getAspectFitRect(origin: self.size, destination: size)
        let resizedImage = self.resizeImage(image: self, size: aspectFitSize)
        return resizedImage
    }
    
    // ray wenderlich's scale
    func scaledImage(withMaxDimension maxDimension: CGFloat) -> UIImage? {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if self.size.width > self.size.height {
            scaleFactor = self.size.height / self.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = self.size.width / self.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        self.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}


// ============================================================================
// MARK: UIView
// ============================================================================
extension UIView {
    
    func applyBlur(blurStyle: UIBlurEffectStyle) {
        
        // effect
        let blurEffect = UIBlurEffect(style: blurStyle)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        visualEffectView.frame = self.bounds

        self.addSubview(visualEffectView)
    }
    
    func applyBlurredBackgroundView(image: UIImage, blurStyle: UIBlurEffectStyle) {
        
        // effect
        let blurEffect = UIBlurEffect(style: blurStyle)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        visualEffectView.frame = self.bounds
        
        // background image
        let imageView = UIImageView(image: image)
        imageView.frame = self.frame
        imageView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        // apply
        let tempView = UIView(frame: self.frame)
        tempView.backgroundColor = UIColor.clear
        tempView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        tempView.addSubview(imageView)
        tempView.addSubview(visualEffectView)
        self.addSubview(tempView)
    }
    
    func applyVibrancyToSubview(subview: UIView, blurEffect: UIBlurEffect) {
        
        let vibrancy = UIVibrancyEffect(blurEffect: blurEffect)
        let visualEffectView = UIVisualEffectView(effect: vibrancy)
        visualEffectView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        visualEffectView.frame = self.frame
        visualEffectView.contentView.addSubview(subview)

    }
    
    // remember to add gradientLayer.frame = self.view.bounds
    // in viewDidLayoutSubviews() / layoutSubviews()
    func applyGradient(gradientLayer: CAGradientLayer, colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint = CGPoint(x: 0.0, y: 1.0)) {
        
        guard colors.count > 1 else {
            return
        }
        
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        
        let locations = [Int](0..<colors.count)
            .map { Double($0) / Double(colors.count-1) }
            .map { NSNumber(value: $0) }
        
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        gradientLayer.removeFromSuperlayer()
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func applyGradient(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint = CGPoint(x: 0.0, y: 1.0)) {
        
        guard colors.count > 1 else {
            return
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        
        let locations = [Int](0..<colors.count)
            .map { Double($0) / Double(colors.count-1) }
            .map { NSNumber(value: $0) }
        
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        self.layer.addSublayer(gradientLayer)
        //self.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    func applyBorder(color: UIColor) {
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
    }
}

// ============================================================================
// MARK: UITableView
// ============================================================================
extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: animated)
    }
    
    func fixTableViewLayout() {
        // reduce distance to first cell
        // take into consideration a possible headerView

        let yyy = self.visibleCells.first?.frame.origin.y ?? 0
        let headerHeight = self.tableHeaderView?.frame.size.height ?? 0
        
        self.contentInset = UIEdgeInsetsMake(headerHeight - yyy, 0.0, 0.0, 0.0)
    }
    
    func setupBlurred(style: UIBlurEffectStyle = .light) {
        let effect = UIBlurEffect(style: style)
        
        let backgroundView = UIView(frame: self.bounds)
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.applyBlur(blurStyle: style)
        
        self.backgroundColor = UIColor.clear
        self.backgroundView = backgroundView
        self.separatorEffect = UIVibrancyEffect(blurEffect: effect)
    }
    
}



// ============================================================================
// MARK: UIViewController
// ============================================================================
extension UIViewController {
    

    typealias UIAlertOption = (title: String, action: () -> () )
    
    func showAlert(title: String?, message: String?, style: UIAlertControllerStyle, sourceView: UIView? = nil, sourceRect: CGRect? = nil, barButtonItem: UIBarButtonItem? = nil, options: [UIAlertOption] = []) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        alert.addAction(UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.cancel,
            handler: {
                (alertAction: UIAlertAction!) -> Void in
                alert.dismiss(animated: true, completion: nil)
        }))
        
        for option in options {
            let alertAction = UIAlertAction(title: option.title, style: UIAlertActionStyle.default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
                option.action()
            })
            
            alert.addAction(alertAction)
        }
        
        // iPad code needs some additional settings for ActionSheet
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
            && style == UIAlertControllerStyle.actionSheet {
            
            // First we set the modal presentation style to the popover style
            alert.modalPresentationStyle = UIModalPresentationStyle.popover
            
            // Then we tell the popover presentation controller, where the popover should appear
            if let popoverPresentationController = alert.popoverPresentationController {
                // we can have either sourceView & sourceRect
                if let barButtonItem = barButtonItem {
                    popoverPresentationController.barButtonItem = barButtonItem
                }
                else {
                    // or barButtonItem
                    if let sourceView = sourceView, let sourceRect = sourceRect {
                        popoverPresentationController.sourceView = sourceView
                        popoverPresentationController.sourceRect = sourceRect
                    }
                }
            }
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func nearestTabBarController() -> UITabBarController? {
        if self is UITabBarController {
            return self as? UITabBarController
        }
        
        let parentVC = parent != nil ? parent : presentingViewController
        return parentVC?.nearestTabBarController()
    }
    
    
    func setBarButton(title: String?,
                      font: UIFont,
                      imageNormal: String,
                      imageSelected: String,
                      titleNormalColor: UIColor,
                      titleSelectedColor: UIColor) {
        
        let normalImage = UIImage(named: imageNormal)?
            .resizeImageWithAspectFit(size: CGSize(width: 50, height: 50))?
            .withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        let normalSelectedImage = UIImage(named: imageSelected)?
            .resizeImageWithAspectFit(size: CGSize(width: 50, height: 50))?
            .withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        guard case _? = normalImage else {
            print("setBarButton: '\(imageNormal)' not found")
            return
        }
        
        
        let margin : CGFloat = 6.0
        
        if let title = title {
            self.tabBarItem = UITabBarItem(title: title, image: normalImage, selectedImage: normalSelectedImage)
            self.tabBarItem.image = normalImage
            
            self.tabBarItem.setTitleTextAttributes([NSFontAttributeName: font,
                NSForegroundColorAttributeName: titleNormalColor], for: UIControlState.normal)
            self.tabBarItem.setTitleTextAttributes([NSFontAttributeName: font,
                NSForegroundColorAttributeName: titleSelectedColor], for: UIControlState.selected)
        }
        else {
            self.tabBarItem = UITabBarItem(title: nil, image: normalImage, selectedImage: normalSelectedImage)
            self.tabBarItem.image = normalImage
            self.tabBarItem.imageInsets = UIEdgeInsetsMake(margin, 0.0, -margin, 0.0);
        }
        
    }
    
    
    func topBarHeight() -> CGFloat {
    
        var topBarHeight = UIApplication.shared.statusBarFrame.size.height
        if let navigationHeight = self.navigationController?.navigationBar.frame.size.height {
            topBarHeight += navigationHeight
        }
    
        return topBarHeight
    }
}

// ============================================================================
// MARK: MFMailComposeViewController
// ============================================================================
extension MFMailComposeViewController {
    
    class func showMailInterface(subject: String, to: [String], body: String?, parent: UIViewController?) {
        
        // print("======= emailing to: \(to.first)")
        
        if MFMailComposeViewController.canSendMail() {
            
            let mailer = MFMailComposeViewController()
            
            // delegate
            if let parentDelegate = parent as? MFMailComposeViewControllerDelegate {
                mailer.mailComposeDelegate = parentDelegate
            }
            
            // fields
            mailer.setToRecipients(to)
            mailer.setBccRecipients(nil)
            mailer.setSubject(subject)
            if let body = body {
                mailer.setMessageBody(body, isHTML: false)
            }
            
            // NSData *imageData = UIImageJPEGRepresentation(model.originalImage, 0.7);
            // [mailer addAttachmentData:imageData mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"Broadtags_image.jpg"]];
            
            // show the composer
            parent?.present(mailer, animated: true, completion: nil)
        }
        else {
            parent?.showAlert(title: nil, message: "Email is not supported", style: UIAlertControllerStyle.alert)
        }
    }
}


extension UIViewController: UITextFieldDelegate {

    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

/*
extension UIViewController: UIPopoverPresentationControllerDelegate {

    func showPopup(sender: AnyObject, preferredContentSize: CGSize) {
        
        var popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier(ControlCenter.popupViewName) as! APPopupViewController
        popoverContent.preferredContentSize = preferredContentSize
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        var popoverController = popoverContent.popoverPresentationController
        
        // UIPopoverPresentationControllerDelegate Protocol
        popoverController!.delegate = self
        
        popoverController!.sourceView = sender as! UIView
        popoverController!.sourceRect = (sender as! UIView).bounds
        // sau, ca sa arate catre un buton
        //popoverController?.barButtonItem = item
        
        popoverController!.permittedArrowDirections = .Any
        popoverController!.backgroundColor = ControlCenter.dominantColor
        //popoverController!.popoverBackgroundViewClass = custom UIPopoverBackgroundView
        
        self.presentViewController(popoverContent, animated: true, completion: completePresentation)
        
    }
    
    func completePresentation() {
        //println("gata")
    }
    
    public func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // This *forces* a popover to be displayed on the iPhone
        return UIModalPresentationStyle.None

    }
*/

// ============================================================================
// MARK: UITextField
// ============================================================================
extension UITextField {
    
    func setupTheme(
        borderColor: UIColor?,
        borderWidth: CGFloat?,
        backgroundColor: UIColor,
        cornerRadius: CGFloat,
        textColor: UIColor,
        textFont: UIFont,
        placeholderText: String,
        placeholderColor: UIColor,
        placeholderFont: UIFont
        ) {
            
            // most used settings
            // self.keyboardType = UIKeyboardType.EmailAddress
            // self.autocapitalizationType = UITextAutocapitalizationType.None
            // self.autocorrectionType = UITextAutocorrectionType.No
            // self.clearButtonMode = UITextFieldViewMode.WhileEditing
            // self.returnKeyType = UIReturnKeyType.Default
            self.contentVerticalAlignment = UIControlContentVerticalAlignment.center
            
            if let borderWidth = borderWidth, let borderColor = borderColor {
                self.layer.borderColor = borderColor.cgColor
                self.layer.borderWidth = borderWidth
            }
            self.layer.cornerRadius = cornerRadius
            self.layer.backgroundColor = backgroundColor.cgColor
            
            self.font = textFont
            self.textColor = textColor
            
            self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSForegroundColorAttributeName: placeholderColor, NSFontAttributeName: placeholderFont])
    }
    
    
    func setupAccessoryRightButton(title: String, titleColor: UIColor, titleFont: UIFont?, block: @escaping (_ sender: UIButton) -> Void) {
        
        let availableWidth = self.frame.size.width / 2
        let availableHeight = self.frame.size.height * 0.8
        
        
        var titleSize = CGSize.zero
        if let titleFont = titleFont {
            titleSize = title.sizeOfString(constrainedToWidth: availableWidth, height: availableHeight, font: titleFont)
        }
        else {
            titleSize = title.sizeOfString(constrainedToWidth: availableWidth, height: availableHeight, font: self.font!)
        }
        
        let Δ = self.layer.cornerRadius > 0 ? 10 + self.layer.cornerRadius / 2 : 20
        
        let buttonWidth = titleSize.width + Δ
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: availableHeight))
        button.setTitle(title, for: UIControlState.normal)
        button.setTitleColor(textColor, for: UIControlState.normal)
        button.setTitleColor(textColor?.withAlphaComponent(0.5), for: UIControlState.highlighted)
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        button.addAction(block: block)
        
        if let titleFont = titleFont {
            button.titleLabel?.font = titleFont
        }
        else {
            button.titleLabel?.font = self.font
        }
        
        // button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        
        self.rightView = button
        self.rightViewMode = UITextFieldViewMode.always
    }
    
    func setupAccessoryLeftView(imageName: String, scaleFactor: CGFloat) {
        
        let availableHeight = self.frame.size.height * scaleFactor
        
        let leftView = UIImageView(frame: CGRect(x: 0, y: 0, width: availableHeight, height: availableHeight))
        
        leftView.contentMode = UIViewContentMode.scaleAspectFit
        leftView.image = UIImage(named: imageName)
        
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewMode.always
    }
    
    func setupAccessoryRightButton(imageName: String, scaleFactor: CGFloat?, target: AnyObject?, action: Selector) {
        
        guard let buttonImage = UIImage(named: imageName) else {
            return
        }
        
        var availableHeight : CGFloat = 22
        if let scaleFactor = scaleFactor {
            availableHeight = self.frame.size.height * scaleFactor
        }
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: availableHeight, height: availableHeight))
        
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button.contentMode = UIViewContentMode.scaleAspectFit
        button.clipsToBounds = true
        button.setImage(buttonImage, for: UIControlState.normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        
        self.rightView = button
        self.rightViewMode = UITextFieldViewMode.always
    }
    
    func rightButton() -> UIButton? {
        if let rightView = rightView , rightView is UIButton {
            return rightView as? UIButton
        }
        
        return nil
    }
    
    
    func addButtonOnKeyboard(withSize: CGSize, configureButton: @escaping (_ button: UIButton) -> Void,  block: @escaping (_ sender: UIButton) -> Void) {
        
        
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.black
        doneToolbar.isTranslucent = true
        doneToolbar.tintColor = tintColor
        doneToolbar.backgroundColor = UIColor.clear
        doneToolbar.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.any)
        doneToolbar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        
        var items = [UIBarButtonItem]()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        items.append(flexSpace)
        
        if let button = UIBarButtonItem(withSize: withSize, configureButton: configureButton, block: block) {
            items.append(button)
        }
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
        
    }
    
}




// ============================================================================
// MARK: UINavigationBar
// ============================================================================
extension UINavigationBar {
    
    class func setNavigationBar(barStyle: UIBarStyle = UIBarStyle.default, translucent: Bool = true, tintColor: UIColor, bgColor: UIColor, font: UIFont, fontButtons: UIFont) {
        
        // style
        UINavigationBar.appearance().barStyle = barStyle
        // bar bg color
        UINavigationBar.appearance().barTintColor = bgColor
        // bar tint color
        UINavigationBar.appearance().tintColor = tintColor
        // bar title font
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font,
            NSForegroundColorAttributeName: tintColor]
        
        // butoane - tint color, white pentru bg colorat
        UIBarButtonItem.appearance().tintColor = tintColor
        // butoane - font
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: fontButtons],
                                                            for: UIControlState.normal)
    }
    
    class func removeNavigationBarShadow() {
        // remove bottom shadow
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }
    
    class func setupTransparentLight() {
        UINavigationBar.removeNavigationBarShadow()
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        UINavigationBar.appearance().isTranslucent = true
        
//        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
//        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: Design.Fonts.Headline.font,
//            NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
}

// ============================================================================
// MARK: UITabBar
// ============================================================================
extension UITabBar {
    
    class func removeTabBarShadow() {
        // remove upper line
        UITabBar.appearance().shadowImage = UIImage()
        //UITabBar.appearance().backgroundImage = UIImage()
    }
    
    class func setTabBar(barStyle: UIBarStyle, translucent: Bool, tintColor: UIColor, bgColor: UIColor) {
        UITabBar.appearance().barStyle = barStyle
        UITabBar.appearance().isTranslucent = translucent
        UITabBar.appearance().tintColor = tintColor
        UITabBar.appearance().barTintColor = bgColor
        UITabBar.appearance().backgroundImage = UIImage.imageWithColor(color: bgColor)
        UITabBar.appearance().itemPositioning = UITabBarItemPositioning.automatic
    }
}

// ============================================================================
// MARK: UIButton
// ============================================================================
var ButtonAssociatedObjectHandle: UInt8 = 0

class ClosureWrapper : NSObject {
    var block : (_ sender: UIButton) -> Void
    init(block: @escaping (_ sender: UIButton) -> Void) {
        self.block = block
    }
}

extension UIButton {
    
    func addAction(forControlEvents events: UIControlEvents = UIControlEvents.touchUpInside, block: @escaping (_ sender: UIButton) -> Void) {
        let wrapper = ClosureWrapper(block: block)
        objc_setAssociatedObject(self, &ButtonAssociatedObjectHandle, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(self, action: #selector(UIButton.block_handleAction), for: events)
    }
    
    func block_handleAction(sender: UIButton) {
        let wrapper = objc_getAssociatedObject(self, &ButtonAssociatedObjectHandle) as! ClosureWrapper
        wrapper.block(sender)
    }
    
    func setupTheme(borderColor: UIColor,
        borderWidth: CGFloat,
        backgroundColorNormal: UIColor,
        backgroundColorHighlighted: UIColor,
        cornerRadius: CGFloat,
        titleColor: UIColor,
        titleColorHighlighted: UIColor? = nil,
        title: String? = nil,
        titleFont: UIFont
        ) {
            
            self.contentVerticalAlignment = UIControlContentVerticalAlignment.center
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = borderWidth
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        
            self.titleLabel?.font = titleFont
            
            if let title = title {
                self.setTitle(title, for: UIControlState.normal)
                self.setTitle(title, for: UIControlState.highlighted)
            }
            
            self.setTitleColor(titleColor, for: UIControlState.normal)
            self.setTitleColor(titleColorHighlighted ?? titleColor, for: UIControlState.highlighted)
            
            self.setBackgroundImage(UIImage.imageWithColor(color: backgroundColorNormal), for: UIControlState.normal)
            self.setBackgroundImage(UIImage.imageWithColor(color: backgroundColorHighlighted), for: UIControlState.highlighted)
    }
    
    
    func setupImage(image: UIImage) {
        self.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        self.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.contentMode = UIViewContentMode.scaleAspectFit
        // self.layer.masksToBounds = true
        self.clipsToBounds = true
        // self.layer.borderColor = UIColor.greenColor().CGColor
        // self.layer.borderWidth = 1
        self.setImage(image, for: UIControlState.normal)
    }
    
    
    convenience init?(imageName: String, diameter: CGFloat?, block: @escaping (_ sender: UIButton) -> Void) {
        
        guard let buttonImage = UIImage(named: imageName) else {
            return nil
        }
        
        let buttonDiameter : CGFloat = diameter ?? 22

        self.init(frame: CGRect(x: 0, y: 0, width: buttonDiameter, height: buttonDiameter))
        
        self.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.contentMode = UIViewContentMode.scaleAspectFit
        self.clipsToBounds = true
        self.setImage(buttonImage, for: UIControlState.normal)
        self.addAction(block: block)
        
        // button.showsTouchWhenHighlighted = true
        // button.layer.borderColor = UIColor.whiteColor().CGColor
        // button.layer.borderWidth = 1
    }
    
    convenience init?(imageName: String, diameter: CGFloat?, target: AnyObject?, action: Selector) {
        
        guard let buttonImage = UIImage(named: imageName) else {
            return nil
        }
        
        let buttonDiameter : CGFloat = diameter ?? 22
        
        self.init(frame: CGRect(x: 0, y: 0, width: buttonDiameter, height: buttonDiameter))

        self.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.contentMode = UIViewContentMode.scaleAspectFit
        self.clipsToBounds = true
        self.setImage(buttonImage, for: UIControlState.normal)
        self.addTarget(target, action: action, for: .touchUpInside)
        
        // button.showsTouchWhenHighlighted = true
        // button.layer.borderColor = UIColor.whiteColor().CGColor
        // button.layer.borderWidth = 1
    }
    
}

// ============================================================================
// MARK: UIBarButtonItem
// ============================================================================
extension UIBarButtonItem {
    
    convenience init?(withSize: CGSize = CGSize(width: 22, height: 22), configureButton: ((_ button: UIButton) -> Void)? = nil,  block: @escaping (_ sender: UIButton) -> Void) {
        
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: withSize))
        button.contentMode = UIViewContentMode.scaleAspectFit
        button.clipsToBounds = true
        button.addAction(block: block)
        configureButton?(button)
        
        self.init(customView: button)
    }

    
    convenience init?(imageName: String, ofSize: CGSize = CGSize(width: 22, height: 22), block: @escaping (_ sender: UIButton) -> Void) {
        
        guard let buttonImage = UIImage(named: imageName) else {
            return nil
        }
        
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: ofSize))
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button.contentMode = UIViewContentMode.scaleAspectFit
        button.clipsToBounds = true
        button.setImage(buttonImage, for: UIControlState.normal)
        button.addAction(block: block)
        
        self.init(customView: button)
    }
    
    convenience init?(image: UIImage? = nil, ofSize: CGSize = CGSize(width: 22, height: 22), block: @escaping (_ sender: UIButton) -> Void) {
        
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: ofSize))
        // button.applyThemeBar()
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button.contentMode = UIViewContentMode.scaleAspectFit
        button.clipsToBounds = true
        button.setImage(image, for: UIControlState.normal)
        button.addAction(block: block)
        
        self.init(customView: button)
    }
    
    convenience init?(imageName: String, target: AnyObject?, action: Selector) {
        
        guard let buttonImage = UIImage(named: imageName) else {
            return nil
        }
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button.contentMode = UIViewContentMode.scaleAspectFit
        button.clipsToBounds = true
        button.setImage(buttonImage, for: UIControlState.normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        
        self.init(customView: button)
    }
    
    func setupImage(image: UIImage, forState: UIControlState) {
        if let button = self.customView as? UIButton {
            button.setImage(image, for: forState)
        }
    }
    
}

// ============================================================================
// MARK: UIGestureRecognizer
// Created by Hsoi, Swift-ized by JLandon.
// ============================================================================

extension UIGestureRecognizer {
    
    private class GestureAction {
        var action: (UIGestureRecognizer) -> Void
        
        init(action: @escaping (UIGestureRecognizer) -> Void) {
            self.action = action
        }
    }
    
    private struct AssociatedKeys {
        static var ActionName = "action"
    }
    
    private var gestureAction: GestureAction? {
        set { objc_setAssociatedObject(self, &AssociatedKeys.ActionName, newValue, .OBJC_ASSOCIATION_RETAIN) }
        get { return objc_getAssociatedObject(self, &AssociatedKeys.ActionName) as? GestureAction }
    }
    
    
    convenience init(action: @escaping (UIGestureRecognizer) -> Void) {
        self.init()
        gestureAction = GestureAction(action: action)
        addTarget(self, action: #selector(UIGestureRecognizer.handleAction))
    }
    
    dynamic private func handleAction(recognizer: UIGestureRecognizer) {
        gestureAction?.action(recognizer)
    }
    

    
}



