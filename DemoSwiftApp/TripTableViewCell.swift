//
//  TripTableViewCell.swift
//  DemoSwiftApp
//
//  Custom cell for displaying trip information in a modern, card-based layout
//

import UIKit

class TripTableViewCell: UITableViewCell {
    static let identifier = "TripTableViewCell"

    // UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.secondaryBackground
        view.layer.cornerRadius = Theme.cornerRadius
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let iconView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.primaryGreen.withAlphaComponent(0.1)
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let carIconLabel: UILabel = {
        let label = UILabel()
        label.text = "🚗"
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.captionFont
        label.textColor = Theme.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let startLocationLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.boldBodyFont
        label.textColor = Theme.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let endLocationLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.bodyFont
        label.textColor = Theme.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let distanceLabel = UILabel()
    private let durationLabel = UILabel()
    private let scoreLabel = UILabel()

    private let scoreCircleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let scoreValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.addSubview(iconView)
        iconView.addSubview(carIconLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(startLocationLabel)
        containerView.addSubview(endLocationLabel)
        containerView.addSubview(statsStackView)
        containerView.addSubview(scoreCircleView)
        scoreCircleView.addSubview(scoreValueLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Theme.smallPadding),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.padding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.padding),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Theme.smallPadding),

            iconView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Theme.padding),
            iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Theme.padding),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),

            carIconLabel.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            carIconLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),

            dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Theme.padding),
            dateLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: scoreCircleView.leadingAnchor, constant: -8),

            startLocationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            startLocationLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            startLocationLabel.trailingAnchor.constraint(equalTo: scoreCircleView.leadingAnchor, constant: -8),

            endLocationLabel.topAnchor.constraint(equalTo: startLocationLabel.bottomAnchor, constant: 2),
            endLocationLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            endLocationLabel.trailingAnchor.constraint(equalTo: scoreCircleView.leadingAnchor, constant: -8),

            scoreCircleView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Theme.padding),
            scoreCircleView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Theme.padding),
            scoreCircleView.widthAnchor.constraint(equalToConstant: 30),
            scoreCircleView.heightAnchor.constraint(equalToConstant: 30),

            scoreValueLabel.centerXAnchor.constraint(equalTo: scoreCircleView.centerXAnchor),
            scoreValueLabel.centerYAnchor.constraint(equalTo: scoreCircleView.centerYAnchor),

            statsStackView.topAnchor.constraint(equalTo: endLocationLabel.bottomAnchor, constant: 12),
            statsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Theme.padding),
            statsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Theme.padding),
            statsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Theme.padding)
        ])

        setupStatLabels()
    }

    private func setupStatLabels() {
        [distanceLabel, durationLabel].forEach { label in
            label.font = Theme.captionFont
            label.textColor = Theme.textSecondary
            label.textAlignment = .left
        }

        statsStackView.addArrangedSubview(createStatView(label: distanceLabel, icon: "📍"))
        statsStackView.addArrangedSubview(createStatView(label: durationLabel, icon: "⏱"))
    }

    private func createStatView(label: UILabel, icon: String) -> UIView {
        let container = UIView()
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = .systemFont(ofSize: 14)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false

        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(iconLabel)
        container.addSubview(label)

        NSLayoutConstraint.activate([
            iconLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),

            label.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])

        return container
    }

    func configure(with trip: Trip) {
        dateLabel.text = trip.dateRangeFormatted
        startLocationLabel.text = trip.startAddress ?? "Start Location"
        endLocationLabel.text = "→ \(trip.endAddress ?? "End Location")"
        distanceLabel.text = trip.distanceFormatted
        durationLabel.text = trip.durationFormatted

        if let score = trip.score {
            scoreCircleView.isHidden = false
            scoreValueLabel.text = "\(score)"
            scoreCircleView.backgroundColor = Theme.scoreColor(for: score)
        } else {
            scoreCircleView.isHidden = true
        }
    }
}
