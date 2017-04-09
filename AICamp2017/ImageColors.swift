//
//  ImageColors.swift
//  AICamp2017
//
//  Created by Darius Miliauskas on 09/04/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class ImageColors: NSObject {
    
    func cgImageFromUIImage(_ uiImage: UIImage) -> CGImage? {
        if let ciImage = CIImage(image: uiImage), let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) {
            return cgImage
        }
        return nil
    }
    
    func convertToColors(cgImage: CGImage) -> [[Float]] {
        let dimension: Int = 100
        let rgba = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4*dimension*dimension)
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let info = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        let context: CGContext = CGContext(data: rgba, width: dimension, height: dimension, bitsPerComponent: 8, bytesPerRow: 400, space: colorSpace, bitmapInfo: info.rawValue)!
        context.draw(cgImage, in: CGRect(x: 0.0, y: 0.0, width: Double(dimension), height: Double(dimension)))

        var colours: [[Float]] = []
        
        for index1 in 0..<dimension {
            for index2 in 0..<dimension {
                let index = 4*(index1*dimension + index2)
                let r: Int = Int(rgba[index])
                let g: Int = Int(rgba[index+1])
                let b: Int = Int(rgba[index+2])
                let alpha: Int = Int(rgba[index+3])
                let color: [Float] = [Float(r/255), Float(g/255), Float(b/255), Float(alpha/255)]
                colours.append(color)
            }
        }
        //check for empty image
        guard colours.count>1 else {
            return [[]]
        }
//        if let colours1 = colours as? [[Int]] {
//            print(findTheMainColours(colours: colours1))
//        }
        return colours
    }
}
