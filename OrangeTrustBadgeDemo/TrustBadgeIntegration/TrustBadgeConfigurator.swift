//
//  TrustBadgeConfigurator.swift
//  ESSTrustBadge_iOS
//
//  Created by Marc Beaudoin on 23/08/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import Foundation
import OrangeTrustBadge
#if HEALTHKIT
import HealthKit
#endif

//MARK: TrustBadge integration
extension ViewController {
    /*
     Setting up TrustBadge
     */
    func setupTrustBadge(statusBarStyle: UIStatusBarStyle) {
        
        // Let's begin OrangeTrustBadge's integration
        let config = TrustBadgeConfig()
        
        
        
        //
        // CONFIGURE DEVICE PERMISSIONS YOUR APP USE
        //
        
        
        
        // Setup the permissions used by the app
        config.devicePermissions = PersonalData.shared.configuredDevicePermissions.map { return PreDefinedElement(type: $0) }
        
        
        // Comment this section if your app do not use health permission
        #if HEALTHKIT
        if PersonalData.shared.configuredDevicePermissions.contains(.health) {
            config.isHealfDataUsed = {
                // get the current Status of user's health data access
                let objectType = PersonalData.shared.hkReadTypes.first(where: { (objectType) -> Bool in
                    return HKHealthStore().authorizationStatus(for: objectType) == .sharingAuthorized
                })
                
                return objectType == nil ? false : true
            }
        }
        #endif

        // Comment this section if your app do not use homekit
        #if HOMEKIT
        if PersonalData.shared.configuredDevicePermissions.contains(.homekit) {
            config.isHomeKitUsed = { // get the current Status of user's homekit data access
                // consider the user have create a home and you can access it
                // or change this code to be more accurate
                return PersonalData.shared.homeManager.primaryHome != nil
            }
        }
        #endif

        // Comment this section if your app do not use motion activity & fitness permission
        if PersonalData.shared.configuredDevicePermissions.contains(.motionFitness) {
            if #available(iOS 11, *) {} else { // on iOS < 11 only use isMotionFitnessUsed
                config.isMotionFitnessUsed = { return true } // Call here your tracking SDK API to get the current Status of user's motion activity & fitness data access
            }
        }
        
        // uncomment this section to configure a predifined entry in "Main Permissions" (Here we force the Contact element to be always false and hide the "Go to settings" button)
        //if let contactElement = config.elementForType(.contacts).first {
        //    contactElement.shouldBeAutoConfigured = false
        //    contactElement.isConfigurable = false
        //}
        
        
        
        //
        // CONFIGURE APPLICATION DATA YOUR APP USE
        //
        
        
        
        // Remove the data your app do not use from this array below
        config.applicationData = [.notifications,
                                  .identity,
                                  .accountInformations,
                                  .dataUsage,
                                  .advertising].map { return PreDefinedElement(type: $0) }
        
        // enable account credentials usage
        config.isIdentityUsed = {() in return false}
        
        // adds the optionnal data : .history
        config.applicationData.append(PreDefinedElement(type: .history))
        config.isHistoryUsed = {() in return true }
        
        // let TrustBadge know the status of UserTracking (DataUsage) and how to update its state
        config.isTrackingEnabled = {
            // Call here your tracking SDK API to get the current Status
            return UserDefaults.standard.bool(forKey: "TRACKING_KEY")}
        
        // apply a custom behavior when the user toggle the data-usage switch (confirmation popup)
        config.updateTracking = {[weak self] (toggle) in
            if !toggle.isOn{
                let alert = UIAlertController(title: NSLocalizedString("disable-data-usage-confirmation-title", comment: ""), message: NSLocalizedString("disable-data-usage-confirmation-content", comment: ""), preferredStyle: UIAlertController.Style.alert)
                alert.view.tintColor = UIColor.black
                alert.addAction(UIAlertAction(title: NSLocalizedString("disable-data-usage-confirmation-cancel", comment: ""), style: .default, handler: { (action) -> Void in
                    toggle.setOn(true, animated: true)
                }))
                alert.addAction(UIAlertAction(title: NSLocalizedString("disable-data-usage-confirmation-confirm", comment: ""), style: .default, handler: { (action) -> Void in
                    UserDefaults.standard.set(false, forKey: "TRACKING_KEY")
                    // Call here your desactivation API for tracking
                    toggle.setOn(false, animated: true)
                }))
                
                self?.presentedViewController?.present(alert, animated: true, completion: { () -> Void in })
            } else {
                UserDefaults.standard.set(toggle.isOn, forKey: "TRACKING_KEY")
                // Call here your activation API for tracking
            }
        }
        
        
        
        // uncomment this section to add a new custom entry in "Terms and Conditions"
        //let customTerm = Term(type: .Custom, titleKey: "term-custom-title", contentKey: "term-custom-content")
        //config.terms.append(customTerm)
        
        // fill what's displayed in "Terms and Conditions"
        var terms = [Term]()
        terms.append(Term(type: .text, titleKey: "terms-title", contentKey: "terms-content"))
        terms.append(Term(type: .video, titleKey: "terms-video-title", contentKey: "terms-video-content"))
        terms.append(Term(type: .text, titleKey: "terms-data-usage-title", contentKey: "terms-data-usage-content"))
        terms.append(Term(type: .text, titleKey: "terms-help-title", contentKey: "terms-help-content"))
        terms.append(Term(type: .text, titleKey: "terms-more-info-title", contentKey: "terms-more-info-content"))
        config.terms = terms
        
        
        //
        // CONFIGURE TrustBadge UI
        //
        
        
        // uncomment this section to change highlight color used for enabled elements
        //config.highlightColor = UIColor.orangeColor()
        
        // uncomment this section to change the status bar style
        config.statusBarStyle = statusBarStyle
        
        // uncomment this section to change modal presentation style (iOS 13+)
        //config.modalPresentationStyle = .fullScreen

        // uncomment this section to change header logo
        //config.headerLogo = UIImage(named:"my-logo")
        
        // uncomment this section to change header text color
        //config.headerTextColor = .red        
        
        // uncomment this section to change header color
        //config.headerColor = .blue
        
        // finally, initialize TrustBadgeManager with our configuration
        TrustBadge.with(config)
    }
}
