/*
*
* OrangeTrustBadgeDemo
*
* File name:   ViewController.swift
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


import OrangeTrustBadge

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

class ViewController: UIViewController {
    
    @IBOutlet weak var versionLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let shortVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString"),
            let bundleVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") {
            versionLabel.text = "version \(shortVersionString)(\(bundleVersion))"
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func startDemo() {
        
        /// setup the badge
        self.setupTrustBadge()
        
        // register self as a TrustBadgeDelegate for custom view controllers
        TrustBadge.shared.delegate = self
        
        let storyboard = UIStoryboard(name: "OrangeTrustBadge", bundle: Bundle(for: TrustBadge.self))
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if let viewController = storyboard.instantiateInitialViewController(){
                self.present(viewController, animated: true, completion: nil)
            }
        } else {
            // Uncomment this section if you want TrustBage to be presented modally or on an iPad
            //if let viewController = storyboard.instantiateInitialViewController() {
            //  self.present(viewController, animated: true, completion: nil)
            //}
            // Uncomment this section if you want TrustBage to be pushed
            let viewController = storyboard.instantiateViewController(withIdentifier: "LandingController")
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
            let viewController = navigationController.topViewController as? PermissionRequesterViewController {
            viewController.delegate = self
        } else if let viewController = segue.destination as? PermissionRequesterViewController {
            viewController.delegate = self
        }
    }
}



