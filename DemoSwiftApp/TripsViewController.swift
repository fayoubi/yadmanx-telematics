//
//  TripsViewController.swift
//  DemoSwiftApp
//
//  Modern trips list with UITableView and custom cells
//

import UIKit
import TelematicsSDK
import CoreLocation

class TripsViewController: UIViewController {

    // MARK: - UI Components

    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My Trips"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = Theme.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statusStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let trackingStatusView = StatusCardView()
    private let permissionsStatusView = StatusCardView()

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = Theme.backgroundColor
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private let refreshControl = UIRefreshControl()

    // MARK: - Data

    private var trips: [Trip] = []
    private var isLoadingTrips = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatusViews()
        loadTrips()
    }

    deinit {
        RPEntry.instance.locationDelegate = nil
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = Theme.backgroundColor

        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(statusStackView)

        statusStackView.addArrangedSubview(trackingStatusView)
        statusStackView.addArrangedSubview(permissionsStatusView)

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: Theme.padding),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Theme.padding),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -Theme.padding),

            statusStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            statusStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Theme.padding),
            statusStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -Theme.padding),
            statusStackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -Theme.padding),
            statusStackView.heightAnchor.constraint(equalToConstant: 60),

            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        trackingStatusView.configure(title: "Tracking", value: "...", color: Theme.primaryGreen)
        permissionsStatusView.configure(title: "Permissions", value: "...", color: Theme.primaryGreen)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TripTableViewCell.self, forCellReuseIdentifier: TripTableViewCell.identifier)

        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func setupObservers() {
        RPEntry.instance.locationDelegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(trackingStateChanged),
            name: NSNotification.RPTrackerDidChangeActivityNotification,
            object: nil
        )
    }

    // MARK: - Data Loading

    private func loadTrips() {
        guard !isLoadingTrips else { return }
        isLoadingTrips = true

        RPEntry.instance.api.getTracksWithOffset(0, limit: 50) { [weak self] tracks, error in
            DispatchQueue.main.async {
                self?.isLoadingTrips = false
                self?.refreshControl.endRefreshing()

                if let error = error {
                    self?.showError(error.localizedDescription)
                    return
                }

                self?.trips = tracks.compactMap { self?.convertToTrip($0) }
                self?.tableView.reloadData()
            }
        }
    }

    private func convertToTrip(_ track: Any) -> Trip? {
        // Use reflection to extract properties from RPTrack
        let mirror = Mirror(reflecting: track)
        var tripData: [String: Any] = [:]

        for child in mirror.children {
            if let label = child.label {
                tripData[label] = child.value
            }
        }

        // Extract values safely
        guard let trackToken = tripData["trackToken"] as? String,
              let startDate = tripData["startDate"] as? Date,
              let endDate = tripData["endDate"] as? Date else {
            return nil
        }

        let distance = (tripData["distance"] as? Double) ?? 0.0
        let duration = endDate.timeIntervalSince(startDate)

        // Try to get addresses
        let startAddress = tripData["startAddress"] as? String
        let endAddress = tripData["endAddress"] as? String

        return Trip(
            id: trackToken,
            startDate: startDate,
            endDate: endDate,
            startAddress: startAddress,
            endAddress: endAddress,
            distance: distance / 1000.0, // Convert meters to km
            duration: duration,
            score: nil, // Will be populated if available
            averageSpeed: nil,
            maxSpeed: nil
        )
    }

    private func updateStatusViews() {
        let isTracking = RPEntry.instance.isTrackingActive()
        let hasPermissions = RPEntry.instance.isAllRequiredPermissionsGranted()

        trackingStatusView.configure(
            title: "Tracking",
            value: isTracking ? "Active" : "Inactive",
            color: isTracking ? Theme.primaryGreen : Theme.textSecondary
        )

        permissionsStatusView.configure(
            title: "Permissions",
            value: hasPermissions ? "Granted" : "Missing",
            color: hasPermissions ? Theme.primaryGreen : Theme.scorePoor
        )
    }

    // MARK: - Actions

    @objc private func handleRefresh() {
        updateStatusViews()
        loadTrips()
    }

    @objc private func trackingStateChanged() {
        updateStatusViews()
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension TripsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TripTableViewCell.identifier,
            for: indexPath
        ) as? TripTableViewCell else {
            return UITableViewCell()
        }

        let trip = trips[indexPath.row]
        cell.configure(with: trip)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TripsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip = trips[indexPath.row]
        // TODO: Navigate to trip detail view
        print("Selected trip: \(trip.id)")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK: - RPLocationDelegate

extension TripsViewController: RPLocationDelegate {
    func onLocationChanged(_ location: CLLocation) {
        // Handle location updates if needed
    }

    func onNewEvents(_ events: [RPEventPoint]) {
        // Handle events if needed
    }
}

// MARK: - StatusCardView

class StatusCardView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.captionFont
        label.textColor = Theme.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let indicatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = Theme.secondaryBackground
        layer.cornerRadius = 8

        addSubview(indicatorView)
        addSubview(titleLabel)
        addSubview(valueLabel)

        NSLayoutConstraint.activate([
            indicatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Theme.smallPadding),
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: 8),
            indicatorView.heightAnchor.constraint(equalToConstant: 8),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Theme.smallPadding),
            titleLabel.leadingAnchor.constraint(equalTo: indicatorView.trailingAnchor, constant: Theme.smallPadding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Theme.smallPadding),

            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            valueLabel.leadingAnchor.constraint(equalTo: indicatorView.trailingAnchor, constant: Theme.smallPadding),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Theme.smallPadding),
            valueLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -Theme.smallPadding)
        ])
    }

    func configure(title: String, value: String, color: UIColor) {
        titleLabel.text = title
        valueLabel.text = value
        valueLabel.textColor = color
        indicatorView.backgroundColor = color
    }
}
