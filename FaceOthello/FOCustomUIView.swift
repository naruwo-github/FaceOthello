//
//  FOCustomUIView.swift
//  FaceOthello
//
//  Created by Narumi Nogawa on 2020/09/29.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import UIKit

@IBDesignable
class FOCustomUIView : UIView {
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
                self.setViewShadow()
            }
        }
    }
    
    private func setViewShadow() {
        self.clipsToBounds = false
        let layer = self.layer
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: self.shadowOffsetWidth, height: self.shadowOffsetHeight)
        layer.shadowColor = self.shadowColor.cgColor
        layer.shadowRadius = self.shadowRadius
        layer.shadowOpacity = self.shadowOpacity
    }
}

