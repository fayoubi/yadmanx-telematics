//
//  SceneDelegate.swift
//  DemoSwiftApp
//
//  Created by DATA MOTION PTE. LTD. on 09.06.21.
//  Copyright © 2021 DATA MOTION PTE. LTD. All rights reserved.
//

import UIKit
import Foundation
import TelematicsSDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        window?.overrideUserInterfaceStyle = .light
        
        let appName = "\"Swift Demo App\""
        let pages = [
            PageHelper.createPage(
                pageHeader   : "Attention Required!",
                pageText     : "\n\nYou will receive a popup shortly. This popup will ask you for access to your location even when you are not using the app.\n\nPlease, choose ",
                pageBoldText : "“Allow while using App”",
                lastPageText : " for \(appName) to automatically detect when you start a trip.",
                alertHeader  : "Allow \(appName) to access your location?",
                alertText    : "\n\nWe use location service for evaluating your driving manner. By enabling “Always While Using App” on location, the app will be able to automatically determine when you have started and ended a drive",
                buttonTexts  : ["Allow while using App", "Allow Once", "Don’t Allow"],
                coloredButton: "Allow while using App"),
            PageHelper.createPage(
                pageHeader   : "Attention Required!",
                pageText     : "\n\nThen, You will receive a popup to grant us access to your Motion & Fitness activity. We need this information to create a driving score.\n\nPlease, choose ",
                pageBoldText : "“OK”",
                lastPageText : " for \(appName) to grant us access to Motion & Fitness activity.",
                alertHeader  : "\(appName) Would Like to Access Your Motion & Fitness Activity",
                alertText    : "\n\nWe use motion sensors for evaluating your driving manner",
                buttonTexts  : ["Don’t Allow", "OK"],
                coloredButton: "OK"),
            PageHelper.createPage(
                    pageHeader   : "Attention Required!",
                    pageText     : "\n\nAs the next step, You will receive a popup to grant us rights to send you important notifications. You are always able to turn off notifications by categories in the App settings menu.\n\nPlease, choose ",
                    pageBoldText : "“Allow”",
                    lastPageText : " for \(appName) to keep you informed on important events.",
                    alertHeader  : "\(appName) Would Like to Send You Notifications",
                    alertText    : "\n\nNotifications may include alerts, sounds and icon badges. These can be configured in Settings",
                    buttonTexts  : ["Don’t Allow", "Allow"],
                    coloredButton: "Allow"),
            PageHelper.createPage(
                pageHeader   : "Attention Required!",
                pageText     : "\n\nYou will receive a popup shortly for \(appName) to have access to your location even when you are not using the app.\n\nFor the app to work properly\n",
                pageBoldText : "“Change to Always Allow”",
                lastPageText : "",
                alertHeader  : "Allow \(appName) to also access your location even when you are not using the app?",
                alertText    : "\n\nWe use location service for generating a driving score. By enabling “Always” on location, the app will be able to automatically determine when you have started and ended a drive",
                buttonTexts  : ["Keep Only While Using", "Change to Always Allow"],
                coloredButton: "Change to Always Allow")
        ]
        
        RPSettings.returnInstance().wizardPages = pages
        
        //Customization
        RPSettings.returnInstance().wizardNextButtonBgColor = UIColor.red
        RPSettings.returnInstance().wizardMaintextColor = UIColor.black
        RPSettings.returnInstance().wizardAlertBackgroundColor = UIColor.white
        RPSettings.returnInstance().wizardAlertTextColor = UIColor.green
        RPSettings.returnInstance().wizardAlertButtonTextColor = UIColor.blue
        RPSettings.returnInstance().wizardAlertActiveButtonTextColor = UIColor.red
        RPSettings.returnInstance().wizardAlertActiveButtonBgColor = UIColor.gray
        RPSettings.returnInstance().appName = "TelematicsApp"
        
        //Dark Scheme
        //RPSettings.returnInstance().wizardAlertBackgroundColor = UIColor.white
        //RPSettings.returnInstance().wizardAlertTextColor = UIColor.white
        //RPSettings.returnInstance().wizardAlertButtonTextColor = UIColor.white
        //RPSettings.returnInstance().wizardAlertActiveButtonTextColor = UIColor.white
        //RPSettings.returnInstance().wizardAlertActiveButtonBgColor = UIColor.white
        
        RPPermissionsWizard.returnInstance().launch(finish: { finished in
            print("wizard finished: \(finished)")
        })
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        RPEntry.instance.sceneDidBecomeActive(scene)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        RPEntry.instance.sceneWillEnterForeground(scene)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        RPEntry.instance.sceneDidEnterBackground(scene)
    }


}

