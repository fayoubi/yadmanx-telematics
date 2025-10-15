//
//  Trip.swift
//  DemoSwiftApp
//
//  Trip model for displaying trip data
//

import Foundation
import CoreLocation

struct Trip {
    let id: String
    let startDate: Date
    let endDate: Date
    let startAddress: String?
    let endAddress: String?
    let distance: Double // in kilometers
    let duration: TimeInterval // in seconds
    let score: Int?
    let averageSpeed: Double? // km/h
    let maxSpeed: Double? // km/h

    // Computed properties
    var durationFormatted: String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }

    var distanceFormatted: String {
        return String(format: "%.1f km", distance)
    }

    var dateRangeFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let startDateStr = formatter.string(from: startDate)

        formatter.dateFormat = "h:mm a"
        let startTimeStr = formatter.string(from: startDate)
        let endTimeStr = formatter.string(from: endDate)

        return "\(startDateStr) • \(startTimeStr) - \(endTimeStr)"
    }
}

// Extension to create Trip from SDK Track object
extension Trip {
    init(from track: Any) {
        // This will be populated from RPTrack object
        // For now, using dummy implementation
        self.id = UUID().uuidString
        self.startDate = Date()
        self.endDate = Date()
        self.startAddress = "Unknown"
        self.endAddress = "Unknown"
        self.distance = 0
        self.duration = 0
        self.score = nil
        self.averageSpeed = nil
        self.maxSpeed = nil
    }
}
