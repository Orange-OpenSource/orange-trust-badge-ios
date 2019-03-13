/*
*
* OrangeTrustBadge
*
* File name:   LandingController.swift
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

class LandingController: UITableViewController {
    
    static let defaultReuseIdentifier = "DefaultCell"
    
    @IBOutlet weak var header : Header!
    
    private var isSizeClassCompact: Bool {
        return self.splitViewController?.traitCollection.horizontalSizeClass == .compact ||
            self.splitViewController == nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = TrustBadge.shared.localizedString("landing-title")
    }

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .pad{
            self.clearsSelectionOnViewWillAppear = false
        }
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: LandingController.defaultReuseIdentifier)
        tableView.estimatedRowHeight = 70
        NotificationCenter.default.post(name: Notification.Name(rawValue: TrustBadge.TRUSTBADGE_ENTER), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = self.splitViewController {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissModal))
        }

        self.manageLogoVisibility()
        tableView.configure(header: header, with: TrustBadge.shared.localizedString("landing-header-title"),
                            subtitle: TrustBadge.shared.localizedString("landing-header-subtitle"),
                            textColor: TrustBadge.shared.config?.headerTextColor)
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrustBadge.shared.pageDidAppear("Landing")
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.manageLogoVisibility()
    }
    
    /**
     Hide the logo on MasterView when sizeClass != .Compact (e.g on iPad and Iphone6 Plus for instance)
     */
    func manageLogoVisibility(){
        if let header = self.header, let image = header.logo.image {
            if !isSizeClassCompact {
                header.logo.isHidden = true
                header.hiddingConstraint.constant = 0
            } else {
                header.logo.isHidden = false
                header.hiddingConstraint.constant = image.size.width
            }
            header.setNeedsLayout()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let delegate = TrustBadge.shared.delegate,
            let should = delegate.shouldDisplayCustomViewController?(), should else {
            return 3
        }
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0 :
            if isSizeClassCompact {
                let cell = tableView.dequeueReusableCell(withIdentifier: ElementMenuCell.reuseIdentifier, for: indexPath) as! ElementMenuCell
                cell.title.text = TrustBadge.shared.localizedString("landing-permission-title")
                cell.representedObject = TrustBadge.shared.devicePermissions
                cell.content.text = permissionSubtitle
                cell.overview.reloadData()
                cell.customDisclosureIndicator.isHidden = TrustBadge.shared.devicePermissions.count == 0
                cell.selectionStyle = TrustBadge.shared.devicePermissions.count > 0 ? .blue : .none
                cell.contentHeightConstraint.constant = TrustBadge.shared.devicePermissions.count > 0 ? 70 : 0
                cell.setNeedsLayout()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: LandingController.defaultReuseIdentifier, for: indexPath)
                cell.textLabel?.text = TrustBadge.shared.localizedString("landing-permission-title")
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                return cell
            }
        case 1 :
            if isSizeClassCompact {
                let cell = tableView.dequeueReusableCell(withIdentifier: ElementMenuCell.reuseIdentifier, for: indexPath) as! ElementMenuCell
                cell.title.text = TrustBadge.shared.localizedString("landing-application-data-title")
                cell.content.text = applicationDataSubtitle
                cell.representedObject = TrustBadge.shared.applicationData
                cell.overview.reloadData()
                cell.customDisclosureIndicator.isHidden = TrustBadge.shared.applicationData.count == 0
                cell.selectionStyle = TrustBadge.shared.applicationData.count > 0 ? .blue : .none
                cell.contentHeightConstraint.constant = TrustBadge.shared.applicationData.count > 0 ? 70 : 0
                cell.setNeedsLayout()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: LandingController.defaultReuseIdentifier, for: indexPath)
                cell.textLabel?.text = TrustBadge.shared.localizedString("landing-application-data-title")
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                return cell
            }
        case 2 :
            if isSizeClassCompact {
                let cell = tableView.dequeueReusableCell(withIdentifier: TermsMenuCell.reuseIdentifier, for: indexPath) as! TermsMenuCell
                cell.title.text = TrustBadge.shared.localizedString("landing-terms-title")
                cell.content.text = TrustBadge.shared.localizedString("landing-terms-content")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: LandingController.defaultReuseIdentifier, for: indexPath)
                cell.textLabel?.text = TrustBadge.shared.localizedString("landing-terms-title")
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                return cell
            }
            
        default :
            if isSizeClassCompact {
                let cell = tableView.dequeueReusableCell(withIdentifier: CustomMenuCell.reuseIdentifier, for: indexPath) as! CustomMenuCell
                cell.title.text = TrustBadge.shared.localizedString("landing-custom-title")
                cell.content.text = TrustBadge.shared.localizedString("landing-custom-content")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: LandingController.defaultReuseIdentifier, for: indexPath)
                cell.textLabel?.text = TrustBadge.shared.localizedString("landing-custom-title")
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSizeClassCompact {
            return UITableView.automaticDimension
        } else {
            return 55
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Permissions" {
            return TrustBadge.shared.devicePermissions.count > 0
        } else if identifier == "Datas" {
            return TrustBadge.shared.applicationData.count > 0
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0 where UI_USER_INTERFACE_IDIOM() == .phone :
            if TrustBadge.shared.devicePermissions.count > 0 {
                self.performSegue(withIdentifier: "Permissions", sender: self)
            }
        case 0 where UI_USER_INTERFACE_IDIOM() == .pad :
            self.performSegue(withIdentifier: "Permissions", sender: self)
        case 1 where UI_USER_INTERFACE_IDIOM() == .phone :
            if TrustBadge.shared.applicationData.count > 0 {
                self.performSegue(withIdentifier: "Datas", sender: self)
            }
        case 1 where UI_USER_INTERFACE_IDIOM() == .pad :
            self.performSegue(withIdentifier: "Datas", sender: self)
        case 2 :
            self.performSegue(withIdentifier: "Terms", sender: self)
        case 3 :
            if let delegate = TrustBadge.shared.delegate,
                let viewController = delegate.viewController?(at: indexPath) {
                self.showDetailViewController(viewController, sender: self)
            }
        default:
            break
        }
    }
    
    // MARK
    
    @IBAction func dismissModal(){
        self.splitViewController?.preferredDisplayMode = .primaryHidden
        self.splitViewController?.dismiss(animated: true, completion: { () -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: TrustBadge.TRUSTBADGE_LEAVE), object: nil)
        })
    }
    
    
    //MARK: Helpers methods
    
    private func buildSubtitle(from elements: [TrustBadgeElement]) -> String {
        
        // sort by activated
        let elements = elements.sorted { (e1, e2) -> Bool in
            return e1.statusClosure() == true && e2.statusClosure() == false
        }
        
        var numberOfActivatedElements = 0
        let indexOfDisabled = elements.index { $0.statusClosure() == false }
        
        /// All elements are activated
        if indexOfDisabled == nil {
            numberOfActivatedElements = elements.count
        } else if indexOfDisabled == 0 { // None element is activated
            return TrustBadge.shared.localizedString("landing-permission-denied")
        } else {
            numberOfActivatedElements = indexOfDisabled!
        }
        
        let maxIndex = min(ElementMenuCell.maxDisplayedElement, numberOfActivatedElements)
        
        var subtitle = ""
        for index in 0..<maxIndex {
            if let element = elements[index] as? PreDefinedElement {
                let key = "landing-\(element.type.name)-name"
                let value = TrustBadge.shared.localizedString(key)
                
                if subtitle.isEmpty {
                    subtitle = value
                } else if index == maxIndex - 1 {
                    if numberOfActivatedElements > ElementMenuCell.maxDisplayedElement {
                        subtitle += ", " + value + TrustBadge.shared.localizedString("landing-and") + "\(numberOfActivatedElements - maxIndex)" + TrustBadge.shared.localizedString("landing-more")
                    } else {
                        subtitle += TrustBadge.shared.localizedString("landing-and") + value
                    }
                } else {
                    subtitle += ", \(value)"
                }
            }
        }
        return subtitle
    }
    
    private var permissionSubtitle: String {
        guard !TrustBadge.shared.devicePermissions.isEmpty else { return TrustBadge.shared.localizedString("landing-permission-unrequested") }
        
        if let _ = (TrustBadge.shared.devicePermissions.compactMap { return $0 as? PreDefinedElement }.first { $0.isPermissionRequested }) {
            return buildSubtitle(from: TrustBadge.shared.devicePermissions)
        }
        return TrustBadge.shared.localizedString("landing-permission-denied")
    }
    
    private var applicationDataSubtitle: String {
        guard !TrustBadge.shared.applicationData.isEmpty else { return TrustBadge.shared.localizedString("landing-application-data-unrequested") }
        
        if let _ = (TrustBadge.shared.applicationData.compactMap { return $0 as? PreDefinedElement }.first { $0.isPermissionRequested }) {
            return buildSubtitle(from: TrustBadge.shared.applicationData)
        }
        return TrustBadge.shared.localizedString("landing-application-data-denied")
    }
}

extension PreDefinedElement {
    var isPermissionRequested: Bool {
        switch type {

            #if CORELOCATION
        case .location:
            return CLLocationManager.authorizationStatus() != .notDetermined
            #endif
            
            #if CONTACTS
        case .contacts:
            return CNContactStore.authorizationStatus(for: CNEntityType.contacts) != .notDetermined
            #endif
            
            #if PHOTOS
        case .photoLibrary:
            return PHPhotoLibrary.authorizationStatus() != .notDetermined
            #endif
            
            #if MEDIAPLAYER
        case .media:
            if #available(iOS 9.3, *) {
                return MPMediaLibrary.authorizationStatus() != .notDetermined
            } else {
                return false
            }
            #endif
            
            #if EVENTKIT
        case .calendar:
            return EKEventStore.authorizationStatus(for: EKEntityType.event) != .notDetermined
            #endif

            #if CAMERA
        case .camera:
            return AVCaptureDevice.authorizationStatus(for: AVMediaType.video) != .notDetermined
            #endif
            
            #if EVENTKIT
        case .reminders:
            return EKEventStore.authorizationStatus(for: EKEntityType.reminder) != .notDetermined
            #endif
            
            #if BLUETOOTH
        case .bluetoothSharing:
            return CBPeripheralManager.authorizationStatus() != .notDetermined
            #endif
            
            #if MICROPHONE
        case .microphone:
            return AVAudioSession.sharedInstance().recordPermission != .undetermined
            #endif
            
            #if SPEECH
        case .speechRecognition:
            if #available(iOS 10.0, *) {
                #if SPEECH
                return SFSpeechRecognizer.authorizationStatus() != .notDetermined
                #else
                return false
                #endif
            } else {
                return false
            }
            #endif
            
            #if MOTION
        case .motionFitness:
            if #available(iOS 11, *) {
                return CMMotionActivityManager.authorizationStatus() != .notDetermined
            } else {
                return statusClosure()
            }
            #endif

            #if USERNOTIFICATIONS
        case .notifications:
            var status = false
            if #available(iOS 10.0, *) {
                let semaphore = DispatchSemaphore(value: 0)
                UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
                    if settings.authorizationStatus != UNAuthorizationStatus.notDetermined {
                        status = true
                    }
                    semaphore.signal()
                })
                _ = semaphore.wait(timeout: .now() + .seconds(3))
            } else {
                return statusClosure()
            }
            return status
            #endif
            
        default:
            return statusClosure()
        }
    }
}
