//
//  ZHUtility.swift
//  Zeeshan Haider
//
//  Created by Zeeshan Haider on 02/12/2017.
//  Copyright © 2017 ZHMaskingCamera. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit
extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}

public class ZHUtility {
    class func mask(_ view: UIView, maskImage: UIImage) {
        let mask = CALayer()
        mask.contents = maskImage.cgImage
        mask.frame = CGRect(x: 0, y: 0, width: maskImage.size.width, height: maskImage.size.height)
        view.layer.mask = mask
        view.layer.masksToBounds = true
    }
    class func maskLayer(_ layer: CALayer, maskImage: UIImage) {
        let mask = CALayer()
        mask.contents = maskImage.cgImage
        mask.frame = CGRect(x: 0, y: 0, width: maskImage.size.width, height: maskImage.size.height)
        layer.mask = mask
        layer.masksToBounds = true
    }
    
    class func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    class func maskImage(image: UIImage, maskImage: UIImage) -> UIImage? {
        
        let image1 = image.fixOrientation()
        let size = image1.size
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        // Begin graphics
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.translateBy(x: 0.0, y: image1.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let mask = maskImage.cgImage
        
        context.clip(to: rect, mask: mask!)
        context.draw(image1.cgImage!, in: rect)
        
        let img =  UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
        
    }
}
