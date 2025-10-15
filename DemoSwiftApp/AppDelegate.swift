//
//  AppDelegate.swift
//  DemoSwiftApp
//
//  Created by DATA MOTION PTE. LTD. on 09.06.21.
//  Copyright © 2021 DATA MOTION PTE. LTD. All rights reserved.
//

import UIKit
import TelematicsSDK
import AdSupport

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RPSpeedLimitDelegate, RPTrackingStateListenerDelegate, RPAccuracyAuthorizationDelegate, RPLowPowerModeDelegate {
    
    var timeThreshold: TimeInterval = 5

    var speedLimit: Double = 100

    func speedLimitNotification(
        _ speedLimit: Double,
        speed: Double,
        latitude: Double,
        longitude: Double,
        date: Date
    ) {
        self.showNotification(
            title: "Overspeed",
            body: String(format: "You speed is %f at lat: %f lon:%f", speed, latitude, longitude)
        )
    }

    func trackingStateChanged(_ state: Bool) {
        var body = "Tracking Stopped"
        if state {
            body = "Tracking Started"
        }
        self.showNotification(
            title: "Tracking State",
            body: body
        )
    }

    func wrongAccuracyAuthorization() {
        self.showNotification(
            title: "Precise Location is off",
            body: "Your trips may be not recorded. Please, follow to App Settings=>Location=>Precise Location"
        )
    }

    func lowPowerMode(_ state: Bool) {
        if (state) {
            self.showNotification(
                title: "Low Power Mode",
                body: "Your trips may be not recorded. Please, follow to Settings=>Battery=>Low Power"
            )
        }
    }
    
    func showNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = body
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 5,
            repeats: false
        )

        // choose a random identifier
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Initialize the SDK - MUST be first
        RPEntry.initializeSDK()

        // Pass launch options to SDK
        let options = launchOptions ?? [:]
        RPEntry.instance.application(application, didFinishLaunchingWithOptions: options)

        // Setup delegates
        RPEntry.instance.trackingStateDelegate = self
        RPEntry.instance.speedLimitDelegate = self
        RPEntry.instance.accuracyAuthorizationDelegate = self
        RPEntry.instance.lowPowerModeDelegate = self

        // Setup advertising identifier if available
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            RPEntry.instance.advertisingIdentifier = ASIdentifierManager.shared().advertisingIdentifier
        }

        // Set DeviceToken - Must be set before permissions wizard
        //Fahd
        let deviceToken = "d968bcef-581a-448b-9912-33441c9bfa37"
        //Ghizlane
        //let deviceToken = "1fd464b1-7600-482b-9064-f93fd12882dc"
        RPEntry.instance.virtualDeviceToken = deviceToken

        // Setup permissions wizard
        RPPermissionsWizard.returnInstance().launch(finish: { finished in
            print("Permissions wizard finished: \(finished)")

            // Enable tracking after permissions are granted
            RPEntry.instance.disableTracking = false

            // Explicitly enable HF (High Frequency) data collection for better accuracy
            //RPEntry.instance.enableHF = true

            print("Tracking enabled. disableTracking = \(RPEntry.instance.disableTracking)")
        })

        return true
    }
    
    // MARK: SDK Integration
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        RPEntry.instance.applicationDidReceiveMemoryWarning(application)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        RPEntry.instance.applicationWillTerminate(application)
    }
    
    func application(
        _ application: UIApplication,
        performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        RPEntry.instance.application(application) {
            completionHandler(.newData)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
        
    }

    func application(
        _ application: UIApplication,
        handleEventsForBackgroundURLSession identifier: String,
        completionHandler: @escaping () -> Void
    ) {
        RPEntry.instance.application(
            application,
            handleEventsForBackgroundURLSession: identifier,
            completionHandler: completionHandler
        )
    }
    
}

