//
//  ProfileViewController.swift
//  DemoSwiftApp
//
//  Profile screen displaying user information
//

import UIKit
import TelematicsSDK

class ProfileViewController: UIViewController {

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

    // Header with background image
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let profileImageView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.42, green: 0.54, blue: 0.75, alpha: 1.0)
        view.layer.cornerRadius = 60
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let profileIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let verifiedStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let verifiedIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let verifiedLabel: UILabel = {
        let label = UILabel()
        label.text = "Verified Account"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email: "
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(white: 0.8, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Profile Information Section
    private let profileInfoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile Information"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = Theme.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let profileInfoCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let dobLabel: UILabel = {
        let label = UILabel()
        label.text = "Date of Birth"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = Theme.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dobValueLabel: UILabel = {
        let label = UILabel()
        label.text = "Not specified"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = Theme.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Address"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = Theme.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let addressValueLabel: UILabel = {
        let label = UILabel()
        label.text = "Not specified"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = Theme.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let cardIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "creditcard")
        imageView.tintColor = UIColor(white: 0.7, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = UIColor(white: 0.7, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // Vehicles Section
    private let vehiclesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Vehicles"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = Theme.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let addVehicleCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let addVehicleButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let plusIconView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.27, green: 0.84, blue: 0.46, alpha: 1.0)
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let plusIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let addVehicleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add New Vehicle"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = Theme.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Data

    private var userEmail: String = ""

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadUserData()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = Theme.backgroundColor

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Header
        contentView.addSubview(headerView)
        headerView.addSubview(profileImageView)
        profileImageView.addSubview(profileIconImageView)
        headerView.addSubview(settingsButton)
        headerView.addSubview(verifiedStackView)
        verifiedStackView.addArrangedSubview(verifiedIconImageView)
        verifiedStackView.addArrangedSubview(verifiedLabel)
        headerView.addSubview(emailLabel)

        // Profile Information
        contentView.addSubview(profileInfoTitleLabel)
        contentView.addSubview(profileInfoCard)
        profileInfoCard.addSubview(cardIconImageView)
        profileInfoCard.addSubview(dobLabel)
        profileInfoCard.addSubview(dobValueLabel)
        profileInfoCard.addSubview(addressLabel)
        profileInfoCard.addSubview(addressValueLabel)
        profileInfoCard.addSubview(chevronImageView)

        // Vehicles
        contentView.addSubview(vehiclesTitleLabel)
        contentView.addSubview(addVehicleCard)
        addVehicleCard.addSubview(addVehicleButton)
        addVehicleCard.addSubview(plusIconView)
        plusIconView.addSubview(plusIconImageView)
        addVehicleCard.addSubview(addVehicleLabel)

        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Header
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 280),

            // Profile Image
            profileImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 60),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),

            profileIconImageView.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            profileIconImageView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            profileIconImageView.widthAnchor.constraint(equalToConstant: 60),
            profileIconImageView.heightAnchor.constraint(equalToConstant: 60),

            // Settings Button
            settingsButton.topAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.topAnchor, constant: 16),
            settingsButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            settingsButton.widthAnchor.constraint(equalToConstant: 40),
            settingsButton.heightAnchor.constraint(equalToConstant: 40),

            // Verified Stack
            verifiedStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            verifiedStackView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),

            verifiedIconImageView.widthAnchor.constraint(equalToConstant: 20),
            verifiedIconImageView.heightAnchor.constraint(equalToConstant: 20),

            // Email
            emailLabel.topAnchor.constraint(equalTo: verifiedStackView.bottomAnchor, constant: 8),
            emailLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),

            // Profile Info Title
            profileInfoTitleLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Theme.padding),
            profileInfoTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.padding),
            profileInfoTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.padding),

            // Profile Info Card
            profileInfoCard.topAnchor.constraint(equalTo: profileInfoTitleLabel.bottomAnchor, constant: 12),
            profileInfoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.padding),
            profileInfoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.padding),
            profileInfoCard.heightAnchor.constraint(equalToConstant: 140),

            // Card Icon
            cardIconImageView.leadingAnchor.constraint(equalTo: profileInfoCard.leadingAnchor, constant: Theme.padding),
            cardIconImageView.centerYAnchor.constraint(equalTo: profileInfoCard.centerYAnchor),
            cardIconImageView.widthAnchor.constraint(equalToConstant: 40),
            cardIconImageView.heightAnchor.constraint(equalToConstant: 40),

            // DOB
            dobLabel.topAnchor.constraint(equalTo: profileInfoCard.topAnchor, constant: Theme.padding),
            dobLabel.leadingAnchor.constraint(equalTo: cardIconImageView.trailingAnchor, constant: Theme.padding),

            dobValueLabel.topAnchor.constraint(equalTo: dobLabel.bottomAnchor, constant: 4),
            dobValueLabel.leadingAnchor.constraint(equalTo: dobLabel.leadingAnchor),

            // Address
            addressLabel.topAnchor.constraint(equalTo: dobValueLabel.bottomAnchor, constant: 16),
            addressLabel.leadingAnchor.constraint(equalTo: dobLabel.leadingAnchor),

            addressValueLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 4),
            addressValueLabel.leadingAnchor.constraint(equalTo: addressLabel.leadingAnchor),

            // Chevron
            chevronImageView.trailingAnchor.constraint(equalTo: profileInfoCard.trailingAnchor, constant: -Theme.padding),
            chevronImageView.centerYAnchor.constraint(equalTo: profileInfoCard.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 20),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20),

            // Vehicles Title
            vehiclesTitleLabel.topAnchor.constraint(equalTo: profileInfoCard.bottomAnchor, constant: 24),
            vehiclesTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.padding),
            vehiclesTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.padding),

            // Add Vehicle Card
            addVehicleCard.topAnchor.constraint(equalTo: vehiclesTitleLabel.bottomAnchor, constant: 12),
            addVehicleCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.padding),
            addVehicleCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.padding),
            addVehicleCard.heightAnchor.constraint(equalToConstant: 80),
            addVehicleCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),

            // Add Vehicle Button
            addVehicleButton.topAnchor.constraint(equalTo: addVehicleCard.topAnchor),
            addVehicleButton.leadingAnchor.constraint(equalTo: addVehicleCard.leadingAnchor),
            addVehicleButton.trailingAnchor.constraint(equalTo: addVehicleCard.trailingAnchor),
            addVehicleButton.bottomAnchor.constraint(equalTo: addVehicleCard.bottomAnchor),

            // Plus Icon
            plusIconView.leadingAnchor.constraint(equalTo: addVehicleCard.leadingAnchor, constant: Theme.padding),
            plusIconView.centerYAnchor.constraint(equalTo: addVehicleCard.centerYAnchor),
            plusIconView.widthAnchor.constraint(equalToConstant: 40),
            plusIconView.heightAnchor.constraint(equalToConstant: 40),

            plusIconImageView.centerXAnchor.constraint(equalTo: plusIconView.centerXAnchor),
            plusIconImageView.centerYAnchor.constraint(equalTo: plusIconView.centerYAnchor),
            plusIconImageView.widthAnchor.constraint(equalToConstant: 20),
            plusIconImageView.heightAnchor.constraint(equalToConstant: 20),

            // Add Vehicle Label
            addVehicleLabel.leadingAnchor.constraint(equalTo: plusIconView.trailingAnchor, constant: Theme.padding),
            addVehicleLabel.centerYAnchor.constraint(equalTo: addVehicleCard.centerYAnchor),
        ])

        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        addVehicleButton.addTarget(self, action: #selector(addVehicleTapped), for: .touchUpInside)
    }

    // MARK: - Data Loading

    private func loadUserData() {
        // TODO: Fetch user data from SDK when the correct API method is available
        // For now, displaying placeholder email
        emailLabel.text = "Email: user@example.com"

        // Profile info stays as "Not specified" until real data is available
    }

    // MARK: - Actions

    @objc private func settingsTapped() {
        print("Settings tapped")
        // TODO: Navigate to settings
    }

    @objc private func addVehicleTapped() {
        print("Add vehicle tapped")
        // TODO: Navigate to add vehicle screen
    }
}
