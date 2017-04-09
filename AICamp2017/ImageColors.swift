//
//  ImageColors.swift
//  AICamp2017
//
//  Created by Darius Miliauskas on 09/04/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class ImageColors: UIImage {
    
     var dimension: Int = 10
    
    //find all colors of UIImage
    func findColors() -> [Float] {
        let rgba = getColorsData(dimension: dimension)
        var colours: [Any] = []
        for index1 in 0..<dimension {
            for index2 in 0..<dimension {
                let index = 4*(index1*dimension + index2)
                let colour: UIColor = UIColor(red: CGFloat(rgba[index])/255, green: CGFloat(rgba[index+1])/255, blue: CGFloat(rgba[index+2])/255, alpha: CGFloat(rgba[index+3])/255)
                colours.append(getHueFromUIColor(colour))
            }
        }
        return colours as! [Float]
    }
    
    internal func getColorsData(dimension: Int) -> UnsafeMutablePointer<CUnsignedChar> {
        let rgba = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4*dimension*dimension)
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let info = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        let context: CGContext = CGContext(data: rgba, width: dimension, height: dimension, bitsPerComponent: 8, bytesPerRow: 400, space: colorSpace, bitmapInfo: info.rawValue)!
        
        if let cgImage = self.cgImage() {
            context.draw(cgImage, in: CGRect(x: 0.0, y: 0.0, width: Double(dimension), height: Double(dimension)))
        }
        return rgba
    }
    
    func cgImage() -> CGImage? {
        if let ciImage = CIImage(image: self), let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) {
            return cgImage
        }
        return nil
    }
    
    func getHueFromUIColor(_ color: UIColor) -> Float {
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        color.getHue(&(hsba.h), saturation: &(hsba.s), brightness: &(hsba.b), alpha: &(hsba.a))
        return Float(hsba.h)
    }
}
