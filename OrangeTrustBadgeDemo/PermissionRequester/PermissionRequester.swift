//
//  PermissionRequester.swift
//  ESSTrustBadge_iOS
//
//  Created by Marc Beaudoin on 23/08/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import Foundation

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

extension ViewController: PermissionRequesterDelegate {
    
    // Request speech recognition authorization
    #if SPEECH
    public func requestSpeechRecognitionAuthorization(completionHandler: @escaping ()->Void) {
        if #available(iOS 10.0, *) {
            SFSpeechRecognizer.requestAuthorization { _ in
                completionHandler()
            }
        } else {
            completionHandler()
        }
    }
    #endif
    
    #if MEDIAPLAYER
    public func requestMediaLibraryAuthorization(completionHandler: @escaping ()->Void) {
        if #available(iOS 9.3, *) {
            MPMediaLibrary.requestAuthorization({ (_) in
                completionHandler()
            })
        } else {
            completionHandler()
        }
    }
    #endif
    
    #if MOTION
    public func requestMotionActivityAuthorization(completionHandler: @escaping ()->Void) {
        let manager = CMMotionActivityManager()
        manager.queryActivityStarting(from: Date(), to: Date(), to: OperationQueue()) { _,_  in
            completionHandler()
        }
    }
    #endif
    
    #if HEALTHKIT
    public func requestHealthKitAuthorization(completionHandler: @escaping ()->Void) {
        guard HKHealthStore.isHealthDataAvailable() else { completionHandler(); return }
        HKHealthStore().requestAuthorization(toShare: PersonalData.shared.hkShareTypes, read: PersonalData.shared.hkReadTypes) { _,_ in
            completionHandler()
        }
    }
    #endif

    // Request photoLibrary authorization
    #if PHOTOS
    public func requestPhotoLibraryAuthorization(completionHandler: @escaping ()->Void) {
        PHPhotoLibrary.requestAuthorization { _ in
            completionHandler()
        }
    }
    #endif
    
    // Request camera authorization
    #if CAMERA
    public func requestCameraAuthorization(completionHandler: @escaping ()->Void) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { _ in
            completionHandler()
        }
    }
    #endif
    
    // Request calendar authorization
    #if EVENTKIT
    public func requestCalendarAuthorization(completionHandler: @escaping ()->Void) {
        EKEventStore().requestAccess(to: .event) { _,_  in
            completionHandler()
        }
    }
    #endif
    
    // Request reminders authorization
    #if EVENTKIT
    public func requestReminderAuthorization(completionHandler: @escaping ()->Void) {
        EKEventStore().requestAccess(to: .reminder) { _,_  in
            completionHandler()
        }
    }
    #endif
    
    // Request microphone authorization
    #if MICROPHONE
    public func requestMicrophoneAuthorization(completionHandler: @escaping ()->Void) {
        AVAudioSession().requestRecordPermission {_ in
            completionHandler()
        }
    }
    #endif
    
    // Request contacts authorization
    #if CONTACTS
    public func requestContactAuthorization(completionHandler: @escaping ()->Void) {
        
        CNContactStore().requestAccess(for: .contacts) { _,_  in
            completionHandler()
        }
    }
    #endif
    
    // Request homekit authorization
    #if HOMEKIT
    public func requestHomeKitAuthorization(completionHandler: @escaping ()->Void) {
        _ = PersonalData.shared.homeManager.homes
        completionHandler()
    }
    #endif

    
    // Request Access to UserLocation in order to show them in iOS Preferences Panel
    #if CORELOCATION
    public func requestLocationAuthorization(completionHandler: @escaping ()->Void) {
        PersonalData.shared.requestLocationAuthorization(completionHandler: completionHandler)
    }
    #endif
    
    // Request Bluetooh Sharing authorization
    #if BLUETOOTH
    func requestBluetoothSharingAuthorization(completionHandler: @escaping ()->Void) {
        PersonalData.shared.startAdvertising (completionHandler: completionHandler)
    }
    #endif
    
    // Request PushNotification authorization
    #if USERNOTIFICATIONS
    func requestPushNotificationAuthorization(completionHandler: @escaping ()->Void) {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
                if let error = error {
                    print("\(error)")
                }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                completionHandler()
            }
        }else {
            completionHandler()
        }
    }
    #endif

    func didFinishPerformRequests() {
        startDemo()
    }
}
