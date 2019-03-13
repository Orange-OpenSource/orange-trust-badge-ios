//
//  PersonalData.swift
//  ESSTrustBadge_iOS
//
//  Created by Marc Beaudoin on 25/08/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import CoreLocation
#if HEALTHKIT
import HealthKit
#endif

#if HOMEKIT
import HomeKit
#endif

import CoreBluetooth
import OrangeTrustBadge

class PersonalData: NSObject {
    
    static var shared = PersonalData()
    
    // Location
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    var locationCompletionHandler: (()->Void)?

    // HealthKit
    #if HEALTHKIT
    let hkShareTypes: Set<HKSampleType> = [HKWorkoutType.workoutType()]
    let hkReadTypes: Set<HKObjectType> = [HKWorkoutType.workoutType()]
    #endif
    
    // HomeKit
    #if HOMEKIT
    lazy var homeManager: HMHomeManager = {
        return HMHomeManager()
    }()
    #endif

    // BluetoothManager
    var peripheralManager: CBPeripheralManager?
    var advertigingCompletionHandler: (()->Void)?
    
    // devicePermission used by the app
    // Remove the permissions your app do not use from this array below
    public var configuredDevicePermissions: Set<ElementType> = [.location,
                                                .contacts,
                                                .photoLibrary,
                                                .media,
                                                .calendar,
                                                .camera,
                                                .reminders,
                                                .bluetoothSharing,
                                                .microphone,
                                                .speechRecognition,
                                                .health,
                                                .homekit,
                                                .motionFitness]
    
    // Application Data used by the app
    // Remove the permissions your app do not use from this array below
    public var configuredApplicationData: Set<ElementType> = [.notifications]

    override init() {
        super.init()
    }


    public func updateConfiguredPermissions(with permission: ElementType) {
        if permission.isEnabled {
            configuredDevicePermissions.insert(permission)
        } else {
            if let index = (configuredDevicePermissions.index { return $0.rawValue == permission.rawValue }) {
                configuredDevicePermissions.remove(at: index)
            }
        }
    }

    public func updateConfiguredApplicationData(with permission: ElementType) {
        if permission.isEnabled {
            configuredApplicationData.insert(permission)
        } else {
            if let index = (configuredApplicationData.index { return $0.rawValue == permission.rawValue }) {
                configuredApplicationData.remove(at: index)
            }
        }
    }
}

extension PersonalData: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            advertigingCompletionHandler?()
        }
    }
    
    public func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        self.advertigingCompletionHandler?()
    }

    func startAdvertising(completionHandler: (()->Void)?) {
        self.advertigingCompletionHandler = completionHandler
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
}

extension PersonalData: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        default:
            self.locationCompletionHandler?()
        }
    }
    func requestLocationAuthorization(completionHandler: (()->Void)?) {
        self.locationCompletionHandler = completionHandler
        locationManager.requestAlwaysAuthorization()
    }
}


