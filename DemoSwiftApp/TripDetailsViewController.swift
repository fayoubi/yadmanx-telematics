//
//  TripDetailsViewController.swift
//  DemoSwiftApp
//
//  Trip details view with map, scores, and trip information
//

import UIKit
import MapKit
import TelematicsSDK

class TripDetailsViewController: UIViewController {

    // MARK: - Properties

    var trip: Trip

    // MARK: - UI Components

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = Theme.backgroundColor
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let mapView: MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 0
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .darkGray
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Trip Details"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 48, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let pointsLabel: UILabel = {
        let label = UILabel()
        label.text = "points"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let distanceUnitsLabel: UILabel = {
        let label = UILabel()
        label.text = "mi"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let hoursLabel: UILabel = {
        let label = UILabel()
        label.text = "hours"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let roleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let roleIconView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.primaryGreen
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let roleIconLabel: UILabel = {
        let label = UILabel()
        label.text = "🚗"
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let roleLabel: UILabel = {
        let label = UILabel()
        label.text = "Driver"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let roleToggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "person.slash"), for: .normal)
        button.tintColor = .gray
        button.backgroundColor = Theme.backgroundColor
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .systemRed
        button.backgroundColor = Theme.backgroundColor
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let tripTypeSegmentedControl: UISegmentedControl = {
        let items = ["None", "Personal", "Business"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.backgroundColor = Theme.backgroundColor
        control.selectedSegmentTintColor = Theme.primaryGreen
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private let locationTimelineView = LocationTimelineView()

    private let scoresContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Initialization

    init(trip: Trip) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithTrip()
        setupActions()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = Theme.backgroundColor

        view.addSubview(mapView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Add overlay elements on map
        view.addSubview(backButton)
        view.addSubview(titleLabel)

        // Add all content to contentView
        contentView.addSubview(statsContainer)
        contentView.addSubview(roleContainer)
        contentView.addSubview(tripTypeSegmentedControl)
        contentView.addSubview(locationTimelineView)
        contentView.addSubview(scoresContainer)

        // Stats container subviews
        setupStatsContainer()

        // Role container subviews
        setupRoleContainer()

        // Scores container
        setupScoresContainer()

        NSLayoutConstraint.activate([
            // Map at the top
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 280),

            // Back button
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),

            // Title label
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 150),
            titleLabel.heightAnchor.constraint(equalToConstant: 32),

            // Scroll view below map
            scrollView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Stats container
            statsContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            statsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            statsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            statsContainer.heightAnchor.constraint(equalToConstant: 120),

            // Role container
            roleContainer.topAnchor.constraint(equalTo: statsContainer.bottomAnchor, constant: 8),
            roleContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            roleContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            roleContainer.heightAnchor.constraint(equalToConstant: 70),

            // Trip type segmented control
            tripTypeSegmentedControl.topAnchor.constraint(equalTo: roleContainer.bottomAnchor, constant: 16),
            tripTypeSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 36),
            tripTypeSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -36),
            tripTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 44),

            // Location timeline
            locationTimelineView.topAnchor.constraint(equalTo: tripTypeSegmentedControl.bottomAnchor, constant: 24),
            locationTimelineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            locationTimelineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            // Scores container
            scoresContainer.topAnchor.constraint(equalTo: locationTimelineView.bottomAnchor, constant: 16),
            scoresContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scoresContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scoresContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])

        locationTimelineView.translatesAutoresizingMaskIntoConstraints = false
        scoresContainer.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupStatsContainer() {
        let scoreStack = UIStackView(arrangedSubviews: [scoreLabel, pointsLabel])
        scoreStack.axis = .vertical
        scoreStack.spacing = 0
        scoreStack.alignment = .center
        scoreStack.translatesAutoresizingMaskIntoConstraints = false

        let distanceStack = UIStackView(arrangedSubviews: [distanceLabel, distanceUnitsLabel])
        distanceStack.axis = .vertical
        distanceStack.spacing = 0
        distanceStack.alignment = .center
        distanceStack.translatesAutoresizingMaskIntoConstraints = false

        let durationStack = UIStackView(arrangedSubviews: [durationLabel, hoursLabel])
        durationStack.axis = .vertical
        durationStack.spacing = 0
        durationStack.alignment = .center
        durationStack.translatesAutoresizingMaskIntoConstraints = false

        let mainStack = UIStackView(arrangedSubviews: [scoreStack, distanceStack, durationStack])
        mainStack.axis = .horizontal
        mainStack.distribution = .fillEqually
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        statsContainer.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: statsContainer.topAnchor, constant: 24),
            mainStack.leadingAnchor.constraint(equalTo: statsContainer.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: statsContainer.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: statsContainer.bottomAnchor, constant: -24)
        ])
    }

    private func setupRoleContainer() {
        roleContainer.addSubview(roleIconView)
        roleIconView.addSubview(roleIconLabel)
        roleContainer.addSubview(roleLabel)
        roleContainer.addSubview(roleToggleButton)
        roleContainer.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            roleIconView.leadingAnchor.constraint(equalTo: roleContainer.leadingAnchor, constant: 36),
            roleIconView.centerYAnchor.constraint(equalTo: roleContainer.centerYAnchor),
            roleIconView.widthAnchor.constraint(equalToConstant: 50),
            roleIconView.heightAnchor.constraint(equalToConstant: 50),

            roleIconLabel.centerXAnchor.constraint(equalTo: roleIconView.centerXAnchor),
            roleIconLabel.centerYAnchor.constraint(equalTo: roleIconView.centerYAnchor),

            roleLabel.leadingAnchor.constraint(equalTo: roleIconView.trailingAnchor, constant: 16),
            roleLabel.centerYAnchor.constraint(equalTo: roleContainer.centerYAnchor),

            deleteButton.trailingAnchor.constraint(equalTo: roleContainer.trailingAnchor, constant: -36),
            deleteButton.centerYAnchor.constraint(equalTo: roleContainer.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 40),
            deleteButton.heightAnchor.constraint(equalToConstant: 40),

            roleToggleButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -12),
            roleToggleButton.centerYAnchor.constraint(equalTo: roleContainer.centerYAnchor),
            roleToggleButton.widthAnchor.constraint(equalToConstant: 40),
            roleToggleButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupScoresContainer() {
        let scores = [
            ("Acceleration Score", trip.accelerationScore, UIColor.systemGreen),
            ("Braking Score", trip.brakingScore, UIColor.systemGreen),
            ("Phone Distraction Score", trip.phoneDistractionScore, UIColor.systemBlue),
            ("Speeding Score", trip.speedingScore, UIColor(red: 0.95, green: 0.77, blue: 0.06, alpha: 1.0)),
            ("Cornering Score", trip.corneringScore, UIColor.systemGreen)
        ]

        var previousView: UIView? = nil

        for (index, (title, score, baseColor)) in scores.enumerated() {
            // Use the total trip score as fallback if individual score is not available
            let displayScore = score ?? trip.score ?? 0
            let scoreView = ScoreRowView(title: title, score: displayScore, color: baseColor)
            scoreView.translatesAutoresizingMaskIntoConstraints = false
            scoresContainer.addSubview(scoreView)

            NSLayoutConstraint.activate([
                scoreView.leadingAnchor.constraint(equalTo: scoresContainer.leadingAnchor, constant: 52),
                scoreView.trailingAnchor.constraint(equalTo: scoresContainer.trailingAnchor, constant: -36),
                scoreView.heightAnchor.constraint(equalToConstant: 60)
            ])

            if let previous = previousView {
                scoreView.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 8).isActive = true
            } else {
                scoreView.topAnchor.constraint(equalTo: scoresContainer.topAnchor, constant: 16).isActive = true
            }

            if index == scores.count - 1 {
                scoreView.bottomAnchor.constraint(equalTo: scoresContainer.bottomAnchor, constant: -16).isActive = true
            }

            previousView = scoreView
        }
    }

    // MARK: - Configuration

    private func configureWithTrip() {
        // Configure score
        if let score = trip.score {
            scoreLabel.text = "\(score)"
            scoreLabel.textColor = Theme.scoreColor(for: score)
        }

        // Configure distance - use miles as shown in image
        let miles = trip.distance * 0.621371
        distanceLabel.text = String(format: "%.1f", miles)

        // Configure duration
        let hours = trip.duration / 3600
        let minutes = (trip.duration.truncatingRemainder(dividingBy: 3600)) / 60
        durationLabel.text = String(format: "%02d:%02d", Int(hours), Int(minutes))

        // Configure map
        configureMap()
        mapView.delegate = self

        // Configure location timeline
        locationTimelineView.configure(
            startLocation: trip.startAddress ?? "Unknown",
            endLocation: trip.endAddress ?? "Unknown",
            startTime: trip.startTimeFormatted,
            endTime: trip.endTimeFormatted,
            date: trip.startDateFormatted
        )

        // Configure segmented control
        switch trip.tripType {
        case .none:
            tripTypeSegmentedControl.selectedSegmentIndex = 0
        case .personal:
            tripTypeSegmentedControl.selectedSegmentIndex = 1
        case .business:
            tripTypeSegmentedControl.selectedSegmentIndex = 2
        }
    }

    // MARK: - Map Configuration

    private func configureMap() {
        // Remove any existing annotations and overlays
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)

        print("\n=== MAP CONFIGURATION DEBUG ===")
        print("Trip ID: \(trip.id)")
        print("Has polyline: \(trip.polyline != nil)")
        print("Polyline count: \(trip.polyline?.count ?? 0)")
        print("Start location: \(trip.startLocation?.latitude ?? 0), \(trip.startLocation?.longitude ?? 0)")
        print("End location: \(trip.endLocation?.latitude ?? 0), \(trip.endLocation?.longitude ?? 0)")

        // Check if we have trip route data
        if let polylineCoords = trip.polyline, !polylineCoords.isEmpty {
            print("Using polyline with \(polylineCoords.count) points")
            print("First point: \(polylineCoords.first!.latitude), \(polylineCoords.first!.longitude)")
            print("Last point: \(polylineCoords.last!.latitude), \(polylineCoords.last!.longitude)")
            // Use actual trip points
            configureMapWithPolyline(polylineCoords)
        } else if let startLoc = trip.startLocation, let endLoc = trip.endLocation {
            print("Using start/end fallback")
            // Fallback to straight line between start and end
            configureMapWithStartEnd(startLoc, endLoc)
        } else {
            print("ERROR: No location data available!")
        }
        print("===============================\n")
    }

    private func configureMapWithPolyline(_ coordinates: [CLLocationCoordinate2D]) {
        print("Configuring map with polyline...")

        // Add start and end markers
        if let startCoord = coordinates.first {
            let startAnnotation = MKPointAnnotation()
            startAnnotation.coordinate = startCoord
            startAnnotation.title = "Start"
            mapView.addAnnotation(startAnnotation)
            print("Added start marker at: \(startCoord.latitude), \(startCoord.longitude)")
        }

        if let endCoord = coordinates.last {
            let endAnnotation = MKPointAnnotation()
            endAnnotation.coordinate = endCoord
            endAnnotation.title = "End"
            mapView.addAnnotation(endAnnotation)
            print("Added end marker at: \(endCoord.latitude), \(endCoord.longitude)")
        }

        // Create polyline from all coordinates
        var mutableCoords = coordinates
        let polyline = MKPolyline(coordinates: &mutableCoords, count: coordinates.count)
        mapView.addOverlay(polyline)
        print("Added polyline overlay")

        // Fit map to show entire route with padding
        let rect = polyline.boundingMapRect
        print("Bounding rect - origin: \(rect.origin.x), \(rect.origin.y), size: \(rect.size.width) x \(rect.size.height)")

        let padding = UIEdgeInsets(top: 100, left: 50, bottom: 300, right: 50)
        mapView.setVisibleMapRect(rect, edgePadding: padding, animated: false)
        print("Set visible map rect with padding")

        // Force layout and check final region
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            print("Final map region - center: \(self.mapView.region.center.latitude), \(self.mapView.region.center.longitude)")
            print("Final map span - lat: \(self.mapView.region.span.latitudeDelta), lon: \(self.mapView.region.span.longitudeDelta)")
        }
    }

    private func configureMapWithStartEnd(_ startLoc: CLLocationCoordinate2D, _ endLoc: CLLocationCoordinate2D) {
        // Add start and end markers
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = startLoc
        startAnnotation.title = "Start"

        let endAnnotation = MKPointAnnotation()
        endAnnotation.coordinate = endLoc
        endAnnotation.title = "End"

        mapView.addAnnotations([startAnnotation, endAnnotation])

        // Draw straight line between start and end
        let coordinates = [startLoc, endLoc]
        var mutableCoords = coordinates
        let polyline = MKPolyline(coordinates: &mutableCoords, count: 2)
        mapView.addOverlay(polyline)

        // Calculate region to show both points with padding
        let minLat = min(startLoc.latitude, endLoc.latitude)
        let maxLat = max(startLoc.latitude, endLoc.latitude)
        let minLon = min(startLoc.longitude, endLoc.longitude)
        let maxLon = max(startLoc.longitude, endLoc.longitude)

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )

        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLat - minLat) * 1.5, 0.01),
            longitudeDelta: max((maxLon - minLon) * 1.5, 0.01)
        )

        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
    }

    // MARK: - Actions

    private func setupActions() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        roleToggleButton.addTarget(self, action: #selector(toggleRole), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        tripTypeSegmentedControl.addTarget(self, action: #selector(tripTypeChanged), for: .valueChanged)
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }

    @objc private func toggleRole() {
        trip.isDriver.toggle()
        roleLabel.text = trip.isDriver ? "Driver" : "Passenger"
        roleIconLabel.text = trip.isDriver ? "🚗" : "👤"
    }

    @objc private func deleteTapped() {
        let alert = UIAlertController(
            title: "Delete Trip",
            message: "Are you sure you want to delete this trip?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            // TODO: Implement trip deletion
            self?.backTapped()
        })
        present(alert, animated: true)
    }

    @objc private func tripTypeChanged() {
        switch tripTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            trip.tripType = .none
        case 1:
            trip.tripType = .personal
        case 2:
            trip.tripType = .business
        default:
            break
        }
    }
}

// MARK: - MKMapViewDelegate

extension TripDetailsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = Theme.primaryGreen
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }

        // Customize pin appearance
        if annotation.title == "Start" {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            label.text = "A"
            label.textAlignment = .center
            label.textColor = .white
            label.backgroundColor = Theme.primaryGreen
            label.font = .systemFont(ofSize: 16, weight: .bold)
            label.layer.cornerRadius = 15
            label.clipsToBounds = true
            annotationView?.addSubview(label)
        } else if annotation.title == "End" {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            label.text = "B"
            label.textAlignment = .center
            label.textColor = .white
            label.backgroundColor = Theme.primaryGreen
            label.font = .systemFont(ofSize: 16, weight: .bold)
            label.layer.cornerRadius = 15
            label.clipsToBounds = true
            annotationView?.addSubview(label)
        }

        return annotationView
    }
}

// MARK: - LocationTimelineView

class LocationTimelineView: UIView {

    private let timelineStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let startLocationView = LocationPointView(type: .start)
    private let endLocationView = LocationPointView(type: .end)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white

        addSubview(timelineStackView)
        timelineStackView.addArrangedSubview(startLocationView)
        timelineStackView.addArrangedSubview(endLocationView)

        NSLayoutConstraint.activate([
            timelineStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            timelineStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            timelineStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            timelineStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    func configure(startLocation: String, endLocation: String, startTime: String, endTime: String, date: String) {
        startLocationView.configure(location: startLocation, time: startTime, date: date)
        endLocationView.configure(location: endLocation, time: endTime, date: date)
    }
}

// MARK: - LocationPointView

class LocationPointView: UIView {

    enum PointType {
        case start
        case end
    }

    private let markerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = Theme.primaryGreen
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.primaryGreen
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let sublocationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let type: PointType

    init(type: PointType) {
        self.type = type
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(markerLabel)
        addSubview(dotView)
        addSubview(locationLabel)
        addSubview(sublocationLabel)
        addSubview(timeLabel)

        markerLabel.text = type == .start ? "A" : "B"

        NSLayoutConstraint.activate([
            markerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            markerLabel.topAnchor.constraint(equalTo: topAnchor),
            markerLabel.widthAnchor.constraint(equalToConstant: 30),
            markerLabel.heightAnchor.constraint(equalToConstant: 30),

            dotView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            dotView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            dotView.widthAnchor.constraint(equalToConstant: 10),
            dotView.heightAnchor.constraint(equalToConstant: 10),

            locationLabel.leadingAnchor.constraint(equalTo: dotView.trailingAnchor, constant: 16),
            locationLabel.topAnchor.constraint(equalTo: topAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -8),

            sublocationLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
            sublocationLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 2),
            sublocationLabel.trailingAnchor.constraint(equalTo: locationLabel.trailingAnchor),
            sublocationLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: markerLabel.centerYAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 80)
        ])

        translatesAutoresizingMaskIntoConstraints = false
    }

    func configure(location: String, time: String, date: String) {
        // Split location if it has multiple parts
        let parts = location.components(separatedBy: ",")
        locationLabel.text = parts.first?.trimmingCharacters(in: .whitespaces) ?? location
        if parts.count > 1 {
            sublocationLabel.text = parts.dropFirst().joined(separator: ",").trimmingCharacters(in: .whitespaces)
        }
        timeLabel.text = "\(date),\n\(time)"
        timeLabel.numberOfLines = 2
    }
}

// MARK: - ScoreRowView

class ScoreRowView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let progressBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let progressBar: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var progressWidthConstraint: NSLayoutConstraint?

    init(title: String, score: Int, color: UIColor) {
        super.init(frame: .zero)
        setupUI()
        configure(title: title, score: score, color: color)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(titleLabel)
        addSubview(progressBackground)
        progressBackground.addSubview(progressBar)
        addSubview(scoreLabel)

        progressWidthConstraint = progressBar.widthAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            progressBackground.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            progressBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBackground.trailingAnchor.constraint(equalTo: scoreLabel.leadingAnchor, constant: -12),
            progressBackground.heightAnchor.constraint(equalToConstant: 16),

            progressBar.leadingAnchor.constraint(equalTo: progressBackground.leadingAnchor),
            progressBar.topAnchor.constraint(equalTo: progressBackground.topAnchor),
            progressBar.bottomAnchor.constraint(equalTo: progressBackground.bottomAnchor),
            progressWidthConstraint!,

            scoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: progressBackground.centerYAnchor),
            scoreLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func configure(title: String, score: Int, color: UIColor) {
        titleLabel.text = title
        scoreLabel.text = "\(score)"
        scoreLabel.textColor = Theme.scoreColor(for: score)

        // Set progress bar color based on score
        progressBar.backgroundColor = Theme.scoreColor(for: score)

        // Update progress width after layout
        layoutIfNeeded()
        let maxWidth = progressBackground.bounds.width
        progressWidthConstraint?.constant = maxWidth * CGFloat(score) / 100.0

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        })
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Update constraint based on current width
        if progressWidthConstraint?.constant == 0 {
            let score = Int(scoreLabel.text ?? "0") ?? 0
            let maxWidth = progressBackground.bounds.width
            progressWidthConstraint?.constant = maxWidth * CGFloat(score) / 100.0
        }
    }
}
