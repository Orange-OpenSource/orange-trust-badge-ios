/*
*
* OrangeTrustBadgeDemo
*
* File name:   OrangeButton.swift
* Created:     15/12/2015
* Created by:  Romain BIARD
*
* Copyright 2015 Orange
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import UIKit


@IBDesignable
open class OrangeButton: UIButton {
    
    @IBInspectable var normalBorderColor = UIColor.clear
    @IBInspectable var highlightedBorderColor = UIColor.clear
    
    override open var isHighlighted: Bool {
        willSet(willBeHighlighted) {
            super.isHighlighted = willBeHighlighted
            self.borderColor = willBeHighlighted ? self.highlightedBorderColor : self.normalBorderColor
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        applyBrandCustomization()
        setupBorderColors()
        self.borderWidth = 3
        self.isHighlighted = false
        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func setupBorderColors() {
    }
    
    open override func prepareForInterfaceBuilder() {
        applyBrandCustomization()
    }
    
    func setTitleFont() {
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    }
    
    func applyBrandCustomization() {
    }
}


@IBDesignable
open class OrangeButtonStandard: OrangeButton {
    
    override func setupBorderColors() {
        if #available(iOS 13.0, *) {
            self.normalBorderColor = UIColor.label
        } else {
            self.normalBorderColor = UIColor.black
        }
        self.highlightedBorderColor = UIColor.orange
    }
    
    override func applyBrandCustomization() {
        self.setBackgroundImage(UIImage.imageWithColor(UIColor.clear), for: UIControl.State())
        self.setBackgroundImage(UIImage.imageWithColor(UIColor.orange), for: .highlighted)
        self.setTitleFont()
    }
}

extension UIColor {
    class func orangeKitDarkOrangeColor() -> UIColor { return UIColor(red: 0.5804, green: 0.2235, blue: 0.0196, alpha: 1.0) }
    class func orangeKitGreenColor()      -> UIColor { return UIColor(red: 0.1529, green: 0.6314, blue: 0.1255, alpha: 1.0) }
    class func orangeKitDarkGreenColor()  -> UIColor { return UIColor(red: 0.0902, green: 0.3412, blue: 0.0784, alpha: 1.0) }
    class func orangeKitRedColor()        -> UIColor { return UIColor(red: 0.6824, green: 0.1255, blue: 0.0627, alpha: 1.0) }
    class func orangeKitDarkRedColor()    -> UIColor { return UIColor(red: 0.3686, green: 0.0784, blue: 0.0471, alpha: 1.0) }
}


extension UIButton {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor:self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
}


public extension UIImage {
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
