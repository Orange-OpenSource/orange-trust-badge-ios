/*
*
* OrangeTrustBadge
*
* File name:   TrustBadgeManager.swift
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
#if CORELOCATION
import CoreLocation
#endif
#if CONTACTS
import Contacts
#endif
#if PHOTOS
import Photos
#endif
#if MEDIAPLAYER || CAMERA
import MediaPlayer
#endif
#if EVENTKIT
import EventKit
#endif
#if BLUETOOTH
import CoreBluetooth
#endif
#if MICROPHONE
import AVFoundation
#endif
#if SPEECH
import Speech
#endif
#if USERNOTIFICATIONS
import UserNotifications
#endif
#if MOTION
import CoreMotion
#endif
#if HEALTHKIT
import HealthKit
#endif

@objc public protocol TrustBadgeDelegate {
    /// If this method returns true, the landing page will displayed a cell that allows to access
    //// to this view controller.
    @objc optional func shouldDisplayCustomViewController() -> Bool
    
    /// Implement this method to return a viewController to displayed for the CustomMenuCell
    @objc optional func viewController(at indexPath: IndexPath) -> UIViewController
}

/// TrustBadgeConfig aims to encapsulate all the configuration variables and custom handlers of TrustBadgeManager
@objc open class TrustBadgeConfig : NSObject{
    
    /// Name of the app, (Default : Bundle Display Name of host app)
    @objc open var appName : String?
    
    
    /// (Optional) UIColor used to highlight element with a positive status (default black)
    @objc open var highlightColor = UIColor.black
    
    /// (Optional) background UIColor of the header (default blue)
    @objc open var headerColor = UIColor(red: 57/256, green: 176/256, blue: 168/256, alpha: 1)
    
    /// (Optional) text UIcolor of the header
    @objc open var headerTextColor: UIColor = .black
    
    /// (Optional) UIImage use for the logo of the header
    @objc open var headerLogo : UIImage?

    /// (Optional) Status bar style (default Application's default statusBarStyle)
    @objc open var statusBarStyle = UIApplication.shared.statusBarStyle
    
    /** (Optional) Closure giving Tracking (Data Usage Permission) status (enabled/disabled) (Default : disabled)
     
     Example :
     
     ```
     let config = TrustBadgeConfig()
     config.isTrackingEnabled = {() in return NSUserDefaults.standardUserDefaults().boolForKey("TRACKING_KEY")}
     ```
     */
    @objc open var isTrackingEnabled : () -> Bool = {() in return false}
    
    /// (Optional) Closure giving Identity usage (Identity ElementType) status (enabled/disabled) (Default : disabled)
    @objc open var isIdentityUsed : () -> Bool = {() in return true}
    
    /// (Optional) Closure giving Advertisement (Advertisement ElementType) status (enabled/disabled) (Default : disabled)
    @objc open var isAdvertisementUsed : () -> Bool = {() in return false}
    
    /// (Optional) Closure giving History (history ElementType) status (enabled/disabled) (Default : disabled)
    @objc open var isHistoryUsed : () -> Bool = {() in return false}

    /// (Optional) Closure giving Phone Number (phoneNumber ElementType) status (enabled/disabled) (Default : disabled)
    @objc open var isPhoneNumberUsed : () -> Bool = {() in return false}
    
    /// (Optional) Closure giving health data status (enabled/disabled) (Default : disabled)
    @objc open var isHealfDataUsed : () -> Bool = {() in return false}

    /// (Optional) Closure giving homekit status (enabled/disabled) (Default : disabled)
    @objc open var isHomeKitUsed : () -> Bool = {() in return false}

    /// (Optional) Closure giving Motion & Fitness status (enabled/disabled) (Default : disabled)
    @objc open var isMotionFitnessUsed : () -> Bool = {() in return false}

    /** (Optional) Closure allowing to update the Tracking (Data Usage ElementType) status (enabled/disabled).
     
     Example :
     
     ```
     let config = TrustBadgeConfig()
     config.updateTracking = {(Bool status) in NSUserDefaults.standardUserDefaults().setBool(status, forKey: "TRACKING_KEY")}
     ```
     */
    @objc open var updateTracking : (UISwitch)-> Void = {(toggle) in }
    
    /** (Optional) List of TrustBadgeElements that should be displayed in "Main Elements" section. If you append an TrustBadgeElement to the Array, it will add it at the end of it. If you want to ave full control of what should be displayed, please assign a new array to this property. This section must contains at least 1 element to let TrustBadgeManager initialize properly.
     
     Example :
     
     ```
     let myCustomElement = CustomElement(nameKey: "custom-permission-name-key", descriptionKey: "custom-permission-description-key", statusEnabledIconName: "permission-credit-card-enabled-icon", statusDisabledIconName: "permission-credit-card-disabled-icon")
     myCustomElement.isConfigurable = false
     myCustomElement.statusClosure = {() in return true}
     config.mainElements.append(myCustomElement)
     
     //or with pre-defined permissions such as Calendar :
     
     let calendarElement = PreDefinedElement(type: .Calendar)
     config.mainElements.append(calendarElement)
     ```
     */
    @objc open lazy var devicePermissions = [TrustBadgeElement]()
    
    /** (Optional) List of TrustBadgeElements that should be displayed in "Other Elements" section. If you append an TrustBadgeElement to the Array, it will add it at the end of it. If you want to ave full control of what should be displayed, please assign a new array to this property. If no elements are in the list, this section will not be displayed. (empty by default)
     
     Example :
     
     ```
     let myCustomElement = CustomElement(nameKey: "custom-permission-name-key", descriptionKey: "custom-permission-description-key", statusEnabledIconName: "permission-credit-card-enabled-icon", statusDisabledIconName: "permission-credit-card-disabled-icon")
     myCustomElement.isConfigurable = false
     myCustomElement.statusClosure = {() in return true}
     config.otherElements.append(myCustomElement)
     
     //or with pre-defined permissions such as Calendar :
     
     let calendarElement = PreDefinedElement(type: .Calendar)
     config.otherElements.append(calendarElement)
     ```
     */
    @objc open lazy var applicationData = [TrustBadgeElement]()
    
    
    /** (Optional) List of Terms and Conditions that should be displayed in "terms and conditions" section. (empty by default)
     
     Example :
     
     ```
     let customTerm = Term(type: .Text, titleKey: "terms-data-usage-title", contentKey: "terms-data-usage-content")
     config.terms = [customTerm]
     ```
     */
    @objc open lazy var terms = [Term]()
    
    /**
     Closure called when a page is displayed (optional).
     - Parameters:
     - pageName: the name of the page
     */
    @objc open var pageDidAppear: ((_ pageName: String) -> Void)?

    /**
     Closure to get the localized string for a wording key.
     - Parameters:
     - key: The wording key to localize.
     - Returns:
     The localized string or `nil` to use the default localized string.
     */
    @objc open var localizedString: (_ key: String) -> String? = { key in
        let localizedStringFromAppBundle = NSLocalizedString(key, comment: "")
        if localizedStringFromAppBundle != key {
            return localizedStringFromAppBundle
        }
        let localizedStringFromTrustBadgeBundle = NSLocalizedString(key, tableName: nil, bundle: Bundle(for: TrustBadgeConfig.self), value: "", comment: "")
        if localizedStringFromTrustBadgeBundle != key {
            return localizedStringFromTrustBadgeBundle
        }
        return nil
    }

    /**
     Closure to get the image for a name.
     - Parameters:
     - name: The name of the image to get
     - Returns:
     The image or `nil` to use the default image.
     */
    @objc open var loadImage: (_ name : String) -> UIImage? = { name in
        if let imageFromAppBundle = UIImage(named: name) {
            return imageFromAppBundle
        }
        if let imageFromTrustBadgeBundle = UIImage(named: name, in: Bundle(for: TrustBadgeConfig.self), compatibleWith: nil) {
            return imageFromTrustBadgeBundle
        }
        return nil
    }
    
    /**
     Convenience method to find elements of a given type in order to configure it directly. 
     This method will search over all elements in every collections the Manager is responsible for
     
     - parameter type: type of the Element
     
     - returns: array of PreDefinedElements matching a given type
     */
    @objc open func elementForType(_ type : ElementType) -> [PreDefinedElement] {
        var searchedElements = [PreDefinedElement]()
        for mainElement in self.devicePermissions {
            if mainElement is PreDefinedElement {
                let preDefinedElement = mainElement as! PreDefinedElement
                if preDefinedElement.type == type {
                    searchedElements.append(preDefinedElement)
                }
            }
        }
        for otherElement in self.applicationData {
            if otherElement is PreDefinedElement {
                let preDefinedElement = otherElement as! PreDefinedElement
                if preDefinedElement.type == type {
                    searchedElements.append(preDefinedElement)
                }
            }
        }
        return searchedElements
    }
}

/// TrustBadgeManager Class is the heart of OrangeTrustBadge
@objc open class TrustBadge: NSObject {
    
    /// Event triggered when entering in TrustBadge component
    public static let TRUSTBADGE_ENTER = "TRUSTBADGE_ENTER"
    
    /// Event triggered when entering in Permissions Page
    public static let TRUSTBADGE_PERMISSION_ENTER = "TRUSTBADGE_PERMISSION_ENTER"
    
    /// Event triggered when entering in Usage Page
    public static let TRUSTBADGE_USAGE_ENTER = "TRUSTBADGE_USAGE_ENTER"
    
    /// Event triggered when entering in Terms Page
    public static let TRUSTBADGE_TERMS_ENTER = "TRUSTBADGE_TERMS_ENTER"
    
    /// Event triggered when leaving TrustBadge component
    public static let TRUSTBADGE_LEAVE = "TRUSTBADGE_LEAVE"
    
    /// Event triggered when tapping a TrustBadge element to open/close associated explanations
    public static let TRUSTBADGE_ELEMENT_TAPPED = "TRUSTBADGE_ELEMENT_TAPPED"
    
    /// Event triggered when toggling a TrustBadge element (if toggable)
    public static let TRUSTBADGE_ELEMENT_TOGGLED = "TRUSTBADGE_ELEMENT_TOGGLED"
    
    /// Event triggered when going into iOS settings
    public static let TRUSTBADGE_GO_TO_SETTINGS = "TRUSTBADGE_GO_TO_SETTINGS"
    
    /// Access to the manager's singleton
    public static let shared = TrustBadge()
    
    /// Access to the terms collection
    var terms = [Term]()
    
    var config : TrustBadgeConfig?
    
    /// A TrustBade delegate to manage custom viewcontrollers
    public var delegate: TrustBadgeDelegate?
    
    var devicePermissions  = [TrustBadgeElement]()
    var applicationData = [TrustBadgeElement]()
    
    var css = ""
    var appName = ""
    /**
     Starting point to integrate TrustBadge SDK into your app.
     Simply provide a Configuration object in order to initialize the SDK : it will contains parameters and hooks to customize standard SDK behaviours.
     
     Example :
     
     ```
     let config = TrustBadgeConfig()
     TrustBadgeManager.with(config)
     ```
     
     - parameter configuration: An TrustBadgeConfig containing TrustBadge configuration
     */
    @objc public static func with(_ configuration : TrustBadgeConfig) {
        shared.config = configuration
        shared.initialize()
    }
    
    func initialize(){
        
        //initialize main Elements
        devicePermissions.removeAll()
        if let mainElements = self.config?.devicePermissions{
            self.devicePermissions.append(contentsOf: mainElements)
            self.configurePredefinedElements(self.devicePermissions)
        }
        
        //initialize other Elements
        applicationData.removeAll()
        if let otherElements = self.config?.applicationData{
            self.applicationData.append(contentsOf: otherElements)
            self.configurePredefinedElements(self.applicationData)
        }

        terms.removeAll()
        if let terms = self.config?.terms{
            self.terms.append(contentsOf: terms)
        }
        
        //load css file
        if let cssFromAppBundle = Bundle.main.path(forResource: "style", ofType: "css"){
            self.css = try! String(contentsOfFile: cssFromAppBundle)
        } else {
            let cssFromTrustBadgeBundle = Bundle(for: TrustBadgeConfig.self).path(forResource: "style", ofType: "css")!
            self.css = try! String(contentsOfFile: cssFromTrustBadgeBundle)
        }
        
        //load custom appName
        if let customName = config?.appName{
            self.appName = customName
        } else {
            if let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "kCFBundleDisplayName"){
                self.appName = bundleDisplayName as! String
            } else if let bundleName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String){
                self.appName = bundleName as! String
            } else {
                print("You should setup a custom application name in TrustBadgeConfig")
            }
        }
    }
    
    func configurePredefinedElements(_ elements : [TrustBadgeElement]) {
        for element in elements {
            if let preDefinedElement = element as? PreDefinedElement {
                if preDefinedElement.shouldBeAutoConfigured {
                    
                    switch(preDefinedElement.type){
                    //Device permissions
                        #if CORELOCATION
                    case .location :
                        preDefinedElement.statusClosure = {
                            return ![CLAuthorizationStatus.denied,
                                     CLAuthorizationStatus.notDetermined,
                                     CLAuthorizationStatus.restricted]
                                .contains(CLLocationManager.authorizationStatus())
                        }
                        preDefinedElement.isConfigurable = CLLocationManager.authorizationStatus() != .notDetermined
                        #endif

                        #if CONTACTS
                    case .contacts :
                        preDefinedElement.statusClosure = {
                            return ![CNAuthorizationStatus.denied,
                                     CNAuthorizationStatus.notDetermined,
                                     CNAuthorizationStatus.restricted]
                                .contains(CNContactStore.authorizationStatus(for: CNEntityType.contacts))
                        }
                        preDefinedElement.isConfigurable = true
                        #endif

                        #if PHOTOS
                    case .photoLibrary :
                        preDefinedElement.statusClosure = {
                            return ![PHAuthorizationStatus.denied,
                                     PHAuthorizationStatus.notDetermined,
                                     PHAuthorizationStatus.restricted]
                                .contains(PHPhotoLibrary.authorizationStatus())
                        }
                        preDefinedElement.isConfigurable = PHPhotoLibrary.authorizationStatus() != .notDetermined
                        #endif

                        #if MEDIAPLAYER
                    case .media:
                        preDefinedElement.statusClosure = {
                            if #available(iOS 9.3, *) {
                                return ![MPMediaLibraryAuthorizationStatus.denied,
                                         MPMediaLibraryAuthorizationStatus.notDetermined,
                                         MPMediaLibraryAuthorizationStatus.restricted]
                                    .contains(MPMediaLibrary.authorizationStatus())
                            } else {
                                return false
                            }
                        }
                        if #available(iOS 9.3, *) {
                            preDefinedElement.isConfigurable = MPMediaLibrary.authorizationStatus() != .notDetermined
                        } else {
                            preDefinedElement.isConfigurable = true
                        }
                        #endif
                        
                        #if EVENTKIT
                    case .calendar :
                        preDefinedElement.statusClosure = {
                            return EKEventStore.authorizationStatus(for: EKEntityType.event) == EKAuthorizationStatus.authorized
                        }
                        preDefinedElement.isConfigurable = true
                        #endif

                        #if CAMERA
                    case .camera :
                        preDefinedElement.statusClosure = {
                            return ![AVAuthorizationStatus.denied,
                                     AVAuthorizationStatus.notDetermined,
                                     AVAuthorizationStatus.restricted]
                                .contains(AVCaptureDevice.authorizationStatus(for: AVMediaType.video))
                            }
                        preDefinedElement.isConfigurable = AVCaptureDevice.authorizationStatus(for: AVMediaType.video) != .notDetermined
                        #endif

                        #if EVENTKIT
                    case .reminders :
                        preDefinedElement.statusClosure = {
                            return EKEventStore.authorizationStatus(for: EKEntityType.reminder) == EKAuthorizationStatus.authorized
                        }
                        preDefinedElement.isConfigurable = true
                        #endif

                        #if BLUETOOTH
                    case .bluetoothSharing:
                        preDefinedElement.statusClosure = {
                            return ![CBPeripheralManagerAuthorizationStatus.denied,
                                     CBPeripheralManagerAuthorizationStatus.notDetermined,
                                     CBPeripheralManagerAuthorizationStatus.restricted].contains(CBPeripheralManager.authorizationStatus())
                        }
                        preDefinedElement.isConfigurable = true
                        #endif
                        
                        #if MICROPHONE
                    case .microphone :
                        preDefinedElement.statusClosure = {
                            return ![AVAudioSession.RecordPermission.denied,AVAudioSession.RecordPermission.undetermined].contains(AVAudioSession.sharedInstance().recordPermission)
                            }
                        preDefinedElement.isConfigurable = true
                        #endif

                        #if SPEECH
                    case .speechRecognition:
                        if #available(iOS 10.0, *) {
                            preDefinedElement.statusClosure = {
                                return ![SFSpeechRecognizerAuthorizationStatus.denied,
                                         SFSpeechRecognizerAuthorizationStatus.notDetermined,
                                         SFSpeechRecognizerAuthorizationStatus.restricted].contains(SFSpeechRecognizer.authorizationStatus())
                            }
                            preDefinedElement.isConfigurable = true
                        }
                        #endif

                        #if HEALTHKIT
                    case .health:
                        preDefinedElement.statusClosure = (TrustBadge.shared.config?.isHealfDataUsed)!
                        preDefinedElement.isConfigurable = true
                        #endif

                        #if HOMEKIT
                    case .homekit:
                        preDefinedElement.statusClosure = (TrustBadge.shared.config?.isHomeKitUsed)!
                        preDefinedElement.isConfigurable = true
                        #endif

                        #if MOTION
                    case .motionFitness:
                        if #available(iOS 11, *) {
                            preDefinedElement.statusClosure = {
                                return ![CMAuthorizationStatus.denied,
                                         CMAuthorizationStatus.notDetermined,
                                         CMAuthorizationStatus.restricted]
                                    .contains(CMMotionActivityManager.authorizationStatus())
                            }
                        } else {
                            preDefinedElement.statusClosure = (TrustBadge.shared.config?.isMotionFitnessUsed)!
                        }
                        
                        preDefinedElement.isConfigurable = true
                        #endif

                    //Application data
                    case .accountInformations:
                        preDefinedElement.statusClosure = (TrustBadge.shared.config?.isPhoneNumberUsed)!

                    case .advertising :
                        preDefinedElement.statusClosure = (TrustBadge.shared.config?.isAdvertisementUsed)!
                    
                    case .history :
                        preDefinedElement.statusClosure = (TrustBadge.shared.config?.isHistoryUsed)!

                    case .identity :
                        preDefinedElement.statusClosure = (TrustBadge.shared.config?.isIdentityUsed)!

                    case .dataUsage :
                        preDefinedElement.isToggable = true
                        preDefinedElement.statusClosure = (TrustBadge.shared.config?.isTrackingEnabled)!
                        preDefinedElement.toggleClosure = (TrustBadge.shared.config?.updateTracking)!
                        
                        #if USERNOTIFICATIONS
                    case .notifications:
                        if #available(iOS 10.0, *) {
                            preDefinedElement.statusClosure = {
                                var status = false
                                let semaphore = DispatchSemaphore(value: 0)
                                UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
                                    status = ![UNAuthorizationStatus.denied,
                                               UNAuthorizationStatus.notDetermined].contains(settings.authorizationStatus)
                                    semaphore.signal()
                                })
                                _ = semaphore.wait(timeout: .now() + .seconds(3))
                                return status
                            }
                        }
                        preDefinedElement.isConfigurable = true
                        #endif

                    default:
                        preDefinedElement.isConfigurable = false
                        preDefinedElement.statusClosure = { return false }
                    }
                }
            }
        }
    }

    func pageDidAppear(_ pageName: String) -> Void {
        config?.pageDidAppear?(pageName)
    }

    func localizedString(_ key: String) -> String {
        guard var result = config?.localizedString(key) else {
            return "To be localized key:\(key)"
        }
        result = result.replacingOccurrences(of: "$$cssStylesheet$$", with: TrustBadge.shared.css)
        result = result.replacingOccurrences(of: "$$applicationName$$", with: TrustBadge.shared.appName)
        return result
    }

    func loadImage(_ name: String) -> UIImage {
        guard let result = config?.loadImage(name) else {
            return UIImage(named: "permission-placeholder-icon", in: Bundle(for: TrustBadgeConfig.self), compatibleWith: nil)!
        }
        return result
    }
}
