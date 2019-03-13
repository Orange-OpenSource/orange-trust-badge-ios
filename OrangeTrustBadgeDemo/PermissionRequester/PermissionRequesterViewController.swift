//
//  PermissionRequesterViewController.swift
//  ESSTrustBadge_iOS
//
//  Created by Marc Beaudoin on 23/08/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import UIKit
import OrangeTrustBadge

protocol PermissionRequesterDelegate {
    // Request speech recongnition authorization
    func requestSpeechRecognitionAuthorization(completionHandler: @escaping ()->Void)
    
    // Request media library authorization
    func requestMediaLibraryAuthorization(completionHandler: @escaping ()->Void)
    
    // Request motion & activity authorization
    func requestMotionActivityAuthorization(completionHandler: @escaping ()->Void)
    
    // Request healthkit authorization
    func requestHealthKitAuthorization(completionHandler: @escaping ()->Void)
    
    // Request photoLibrary authorization
    func requestPhotoLibraryAuthorization(completionHandler: @escaping ()->Void)
    
    // Request camera authorization
    func requestCameraAuthorization(completionHandler: @escaping ()->Void)
    
    // Request calendar authorization
    func requestCalendarAuthorization(completionHandler: @escaping ()->Void)
    
    // Request reminders authorization
    func requestReminderAuthorization(completionHandler: @escaping ()->Void)
    
    // Request microphone authorization
    func requestMicrophoneAuthorization(completionHandler: @escaping ()->Void)
    
    // Request contacts authorization
    func requestContactAuthorization(completionHandler: @escaping ()->Void)
    
    // Request homekit authorization
    func requestHomeKitAuthorization(completionHandler: @escaping ()->Void)
    
    // Request Access to UserLocation in order to show them in iOS Preferences Panel
    func requestLocationAuthorization(completionHandler: @escaping ()->Void)
    
    // Request Bluetooh Sharing authorization
    func requestBluetoothSharingAuthorization(completionHandler: @escaping ()->Void)

    // Request PushNotification authorization
    func requestPushNotificationAuthorization(completionHandler: @escaping ()->Void)
    
    func didFinishPerformRequests()
}

extension PermissionRequesterDelegate {
    // Request speech recongnition authorization
    func requestSpeechRecognitionAuthorization(completionHandler: @escaping ()->Void) {completionHandler()}
    
    // Request media library authorization
    func requestMediaLibraryAuthorization(completionHandler: @escaping ()->Void) {completionHandler()}
    
    // Request motion & activity authorization
    func requestMotionActivityAuthorization(completionHandler: @escaping ()->Void) {completionHandler()}
    
    // Request healthkit authorization
    func requestHealthKitAuthorization(completionHandler: @escaping ()->Void) {completionHandler()}
    
    // Request photoLibrary authorization
    func requestPhotoLibraryAuthorization(completionHandler: @escaping ()->Void) {completionHandler()}
    
    // Request camera authorization
    func requestCameraAuthorization(completionHandler: @escaping ()->Void) {completionHandler()}
    
    // Request calendar authorization
    func requestCalendarAuthorization(completionHandler: @escaping ()->Void) {completionHandler()}
    
    // Request reminders authorization
    func requestReminderAuthorization(completionHandler: @escaping ()->Void) {completionHandler()}
    
    // Request microphone authorization
    func requestMicrophoneAuthorization(completionHandler: @escaping ()->Void) {completionHandler()}
    
    // Request contacts authorization
    func requestContactAuthorization(completionHandler: @escaping ()->Void) {completionHandler()}
    
    // Request homekit authorization
    func requestHomeKitAuthorization(completionHandler: @escaping ()->Void) {completionHandler()}
    
    // Request Access to UserLocation in order to show them in iOS Preferences Panel
    func requestLocationAuthorization(completionHandler: @escaping ()->Void) {completionHandler()}
    
    // Request Bluetooh Sharing authorization
    func requestBluetoothSharingAuthorization(completionHandler: @escaping ()->Void) {completionHandler()}
    
    // Request PushNotification authorization
    func requestPushNotificationAuthorization(completionHandler: @escaping ()->Void) {completionHandler()}
}

class PermissionRequesterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var subtitle: UILabel!

    let bundle = Bundle(for: TrustBadge.self)
    var permissions: [ElementType] = ElementType.regularDevicePermissions
    var applicationData: [ElementType] = [.notifications]

    public var delegate: PermissionRequesterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title =  NSLocalizedString("requester-title", comment: "")
        subtitle.text = NSLocalizedString("requester-section-title", comment: "")

        tableView.tableFooterView = UIView()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.title = NSLocalizedString("requester-access-continue", comment: "")
        
        permissions.forEach {
            PersonalData.shared.updateConfiguredPermissions(with: $0)
        }

        applicationData.forEach {
            PersonalData.shared.updateConfiguredApplicationData(with: $0)
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ?  permissions.count : applicationData.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = section == 0 ? "requester-section-permission" : "requester-section-application-data"
        return NSLocalizedString(key, comment: "")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let permission = indexPath.section == 0 ? permissions[indexPath.row] : applicationData[indexPath.row]
        let key = "landing-\(permission.name)-name"
        cell.textLabel?.text = NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
        cell.textLabel?.textColor = .black
        cell.detailTextLabel?.textColor = .black
        
        var permissionEnable = permission.isEnabled
        if !permission.isAuthorizationRequested {
            if indexPath.section == 0 {
                permissionEnable = PersonalData.shared.configuredDevicePermissions.contains(permission) && permissionEnable
            } else {
                permissionEnable = PersonalData.shared.configuredApplicationData.contains(permission) && permissionEnable
            }
        }
        
        if permissionEnable {
            if permission.isAuthorizationRequested {
                cell.accessoryType = .checkmark
                cell.selectionStyle = .none
                cell.detailTextLabel?.text = NSLocalizedString("requester-access-requested", comment: "")
            } else {
                cell.accessoryType = .none
                cell.selectionStyle = .blue
                cell.detailTextLabel?.text = nil
            }
        } else {
            cell.accessoryType = .none
            cell.selectionStyle = .none
            cell.detailTextLabel?.text = NSLocalizedString("requester-access-disabled", comment: "")
            cell.textLabel?.textColor = .lightGray
            cell.detailTextLabel?.textColor = .lightGray
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        var permission = indexPath.section == 0 ? permissions[indexPath.row] : applicationData[indexPath.row]
        guard !permission.isAuthorizationRequested, permission.isEnabled else { return }

        let completionHandler: (()->Void) = {
            permission.isAuthorizationRequested = true
            DispatchQueue.main.async {
                tableView.reloadRows(at: [indexPath], with: .none)                
            }
        }

        switch permission {
        case .location:
            delegate?.requestLocationAuthorization(completionHandler: completionHandler)
            
        case .contacts:
            delegate?.requestContactAuthorization(completionHandler: completionHandler)
            
        case .photoLibrary:
            delegate?.requestPhotoLibraryAuthorization(completionHandler: completionHandler)
        
        case .media:
            delegate?.requestMediaLibraryAuthorization(completionHandler: completionHandler)
        
        case .calendar:
            delegate?.requestCalendarAuthorization(completionHandler: completionHandler)
        
        case .camera:
            delegate?.requestCameraAuthorization(completionHandler: completionHandler)
        
        case .reminders:
            delegate?.requestReminderAuthorization(completionHandler: completionHandler)
        
        case .bluetoothSharing:
            delegate?.requestBluetoothSharingAuthorization(completionHandler: completionHandler)
        
        case .microphone:
            delegate?.requestMicrophoneAuthorization(completionHandler: completionHandler)
        
        case .speechRecognition:
            delegate?.requestSpeechRecognitionAuthorization(completionHandler: completionHandler)
        
        case .health:
            delegate?.requestHealthKitAuthorization(completionHandler: completionHandler)
        
        case .homekit:
            delegate?.requestHomeKitAuthorization(completionHandler: completionHandler)
        
        case .motionFitness:
            delegate?.requestMotionActivityAuthorization(completionHandler: completionHandler)
        
        case .notifications:
            delegate?.requestPushNotificationAuthorization(completionHandler: completionHandler)

        default:
            break
        }
    }

    // Override to support conditional editing of the table view.
    func tableView(_: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        var permission = indexPath.section == 0 ? permissions[indexPath.row] : applicationData[indexPath.row]
        return !permission.isAuthorizationRequested
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var permission = indexPath.section == 0 ? permissions[indexPath.row] : applicationData[indexPath.row]
        let title = NSLocalizedString(permission.isEnabled ? "requester-access-disable-action" : "requester-access-enable-action", comment: "")
        
        return [UITableViewRowAction(style: (permission.isEnabled ? .destructive : .normal), title: title, handler: { (rowAction, indexPath) in
            permission.isEnabled = !permission.isEnabled
            if indexPath.section == 0 {
                self.permissions[indexPath.row] = permission
                PersonalData.shared.updateConfiguredPermissions(with: permission)
            } else {
                self.applicationData[indexPath.row] = permission
                PersonalData.shared.updateConfiguredApplicationData(with: permission)
            }

            tableView.reloadRows(at: [indexPath], with: .none)
        })]
    }
    
    //MARK: IBActions
    @IBAction func `continue`(_ sender: Any) {
        if isBeingPresented {
            super.dismiss(animated: true) {
                self.delegate?.didFinishPerformRequests()
            }
        } else {
            self.delegate?.didFinishPerformRequests()
        }
    }
}

extension ElementType {
    
    enum State: Int {
        case unknown
        case requested
        case enabled
        case disabled
    }
    
    var isAuthorizationRequested: Bool {
        get {
            let state = State(rawValue: UserDefaults.standard.integer(forKey: name))
            return  state == .requested
        }
        set {
            UserDefaults.standard.set(State.requested.rawValue, forKey: name)
        }
    }

    var isEnabled: Bool {
        get {
            let state = State(rawValue: UserDefaults.standard.integer(forKey: name))
            return state != .disabled
        }
        set {
            UserDefaults.standard.set(newValue ? State.enabled.rawValue : State.disabled.rawValue, forKey: name)
        }
    }
}
