/*
 *
 * OrangeTrustBadge
 *
 * File name:   DailymotionPlayer.swift
 * Created:     07/04/2016
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
import WebKit

open class DailymotionPlayer : WKWebView, WKNavigationDelegate {
    
    static let DMAPIVersion = "2.9.3"
    
    let webBaseURLString = "https://www.dailymotion.com"
    
    convenience init(video : String){
        self.init()
        self.load(video)
    }
    
    open func load(_ video : String){
        self.navigationDelegate = self
        
        // Remote white default background
        self.isOpaque = false
        self.backgroundColor = UIColor.clear
        
        // Autoresize by default
        self.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth , UIView.AutoresizingMask.flexibleHeight]
        
        
        // Hack: prevent vertical bouncing
        for subview in self.subviews {
            if (subview.isKind(of: UIScrollView.self)) {
                (subview as! UIScrollView).bounces = false
                (subview as! UIScrollView).isScrollEnabled = false
            }
        }
        
        var url = String(format: "%@/embed/video/%@?api=location&objc_sdk_version=%@&endscreen-enable=false&sharing-enable=false", self.webBaseURLString, video, DailymotionPlayer.DMAPIVersion)
        let appName = Bundle.main.bundleIdentifier;
        
        url = url + String(format: "&app=%@", appName!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        self.load(URLRequest(url: URL(string: url)!))
    }
    
    deinit{
        self.navigationDelegate = nil
        self.stopLoading()
    }
    
    open func pause(){
        self.evaluateJavaScript("player.api(\"pause\", \"null\")")
    }    
}
