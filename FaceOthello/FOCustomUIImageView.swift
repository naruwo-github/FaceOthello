//
//  FOCustomUIImageView.swift
//  FaceOthello
//
//  Created by Narumi Nogawa on 2020/09/29.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import UIKit

@IBDesignable
class FOCustomUIImageView: UIImageView {
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable var shadowOffsetWidth: CGFloat = 2.0 {
        didSet {
            layer.shadowOffset.width = self.shadowOffsetWidth
        }
    }
    
    @IBInspectable var shadowOffsetHeight: CGFloat = 2.0 {
        didSet {
            layer.shadowOffset.height = self.shadowOffsetHeight
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            layer.shadowColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 4.0 {
        didSet {
            layer.shadowRadius = self.shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.4 {
        didSet {
            layer.shadowOpacity = self.shadowOpacity
        }
    }
    
    @IBInspectable var enableShadow: Bool = false {
        didSet {
            if self.enableShadow {
                self.setImageViewShadow()
            }
        }
    }
    
    private func setImageViewShadow() {
        self.clipsToBounds = false
        let layer = self.layer
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: self.shadowOffsetWidth, height: self.shadowOffsetHeight)
        layer.shadowColor = self.shadowColor.cgColor
        layer.shadowRadius = self.shadowRadius
        layer.shadowOpacity = self.shadowOpacity
    }
}

// 参考: https://stackoverflow.com/questions/29137488/how-do-i-resize-the-uiimage-to-reduce-upload-image-size
extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
