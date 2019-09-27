/*
*
* OrangeTrustBadge
*
* File name:   CustomElement.swift
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

import Foundation

/// A CustomElement is a configurable/custom element, often related to your own application logic.
@objc open class CustomElement: TrustBadgeElement {
    /**
     Initializer of of CustomElement
     
     - parameter nameKey:                desired localized Key for CustomElement's name
     - parameter descriptionKey:         desired localized Key for CustomElement's description
     - parameter statusEnabledIconName:  desired icon name for Element's enabled state (using asset catalog)
     - parameter statusDisabledIconName: desired icon name for Element's disabled state (using asset catalog)
     
     - returns: initialized CustomElement object
     */
    @objc public init(nameKey : String, descriptionKey : String, statusEnabledIconName : String, statusDisabledIconName : String){
        super.init()
        self.nameKey = nameKey
        self.descriptionKey = descriptionKey
        self.statusEnabledIconName = statusEnabledIconName
        self.statusDisabledIconName = statusDisabledIconName
    }
}

extension UIColor {
    static var defaultTextColor: UIColor = {
        var defaultColor = UIColor.black
        if #available(iOS 13.0, *) {
            defaultColor = UIColor.label
        }
        return defaultColor
    }()

    var hexString: String {
           var r:CGFloat = 0
           var g:CGFloat = 0
           var b:CGFloat = 0
           var a:CGFloat = 0
           
           getRed(&r, green: &g, blue: &b, alpha: &a)
           
           let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
           
           return String(format:"#%06x", rgb)
    }
}

