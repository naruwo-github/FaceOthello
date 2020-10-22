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

extension UIImage {
    // 参考: https://stackoverflow.com/questions/29137488/how-do-i-resize-the-uiimage-to-reduce-upload-image-size
    // データ量を軽くする関数
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    // 参考: https://qiita.com/saku/items/29c7fa20a62cc2f366fa
    func roundImage() -> UIImage {
        let minLength: CGFloat = min(self.size.width, self.size.height)
        let rectangleSize: CGSize = CGSize(width: minLength, height: minLength)
        UIGraphicsBeginImageContextWithOptions(rectangleSize, false, 0.0)

        UIBezierPath(roundedRect: CGRect(origin: .zero, size: rectangleSize), cornerRadius: minLength).addClip()
        self.draw(in: CGRect(origin: CGPoint(x: (minLength - self.size.width) / 2, y: (minLength - self.size.height) / 2), size: self.size))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }

    // 参考: https://qiita.com/tiqwab/items/846f548416f29b5ae85a
    func composite(image: UIImage) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        // 画像を真ん中に重ねる
        let rect = CGRect(x: (self.size.width - image.size.width)/2,
                          y: (self.size.height - image.size.height)/2,
                          width: image.size.width,
                          height: image.size.height)
        image.draw(in: rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // 参考: https://qiita.com/ruwatana/items/473c1fb6fc889215fca3
    // 画像のサイズ(CGSize)を変更する関数
    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio

        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}
