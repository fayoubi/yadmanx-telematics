//
//  ViewController.swift
//  DemoSwiftApp
//
//  Created by DATA MOTION PTE. LTD. on 09.06.21.
//  Copyright © 2021 DATA MOTION PTE. LTD. All rights reserved.
//

import UIKit
import TelematicsSDK

class ViewController: UIViewController {
    
    @IBOutlet weak var stateLabel : UILabel!
    @IBOutlet weak var permissionLabel : UILabel!
    @IBOutlet weak var currentSpeedLabel : UILabel!
    @IBOutlet weak var tripsView : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RPEntry.instance.locationDelegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.changedActivity),
            name: NSNotification.RPTrackerDidChangeActivityNotification,
            object: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.observePermissions()
    }
    
    deinit {
        RPEntry.instance.locationDelegate = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func observePermissions() {
        DispatchQueue.main.async {
            let isActive = RPEntry.instance.isTrackingActive()
            self.stateLabel.text = "Tracking = \(isActive)"
            let permissions = RPEntry.instance.isAllRequiredPermissionsGranted()
            self.permissionLabel.text = "All Permission Granted = \(permissions)"
            
        }
        RPEntry.instance.api.getTracksWithOffset(0, limit: 10) { [weak self] tracks, error in
            DispatchQueue.main.async { [weak self] in
                self?.tripsView.text = ""
                
                if let error {
                    self?.tripsView.text = "trips load error = \(error.localizedDescription)"
                    return
                }
                
                for track in tracks {
                    let currentText = self?.tripsView.text ?? ""
                    self?.tripsView.text = "\(currentText)\n\(track.trackToken)\n\(track.startDate)\n\(track.endDate)\n"
                }
            }
        }
    }
    
    @objc func changedActivity() {
        DispatchQueue.main.async {
            let isActive = RPEntry.instance.isTrackingActive()
            self.stateLabel.text = "Tracking = \(isActive)"
        }
    }

}

extension ViewController: RPLocationDelegate {
    
    func onLocationChanged(_ location: CLLocation) {
        DispatchQueue.main.async { [weak self] in
            self?.currentSpeedLabel.text = String(format: "speed = %.2f km/h", location.speed)
        }
        print("location = %@", location)
    }
    
    func onNewEvents(_ events: [RPEventPoint]) {
        for event in events {
            print("event = %@", event)
        }
    }
}
