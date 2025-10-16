//
//  MainTabBarController.swift
//  DemoSwiftApp
//
//  Main tab bar navigation with Trips and Profile tabs
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }

    private func setupTabBar() {
        // Dark blue background like the screenshot
        tabBar.barTintColor = UIColor(red: 0.11, green: 0.15, blue: 0.28, alpha: 1.0)
        tabBar.backgroundColor = UIColor(red: 0.11, green: 0.15, blue: 0.28, alpha: 1.0)
        tabBar.isTranslucent = false

        // Unselected item color (gray/white)
        tabBar.unselectedItemTintColor = UIColor(white: 0.7, alpha: 1.0)

        // Selected item color (bright green)
        tabBar.tintColor = UIColor(red: 0.27, green: 0.84, blue: 0.46, alpha: 1.0)

        // Appearance for iOS 15+
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0.11, green: 0.15, blue: 0.28, alpha: 1.0)

            // Unselected state
            let normalAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(white: 0.7, alpha: 1.0)
            ]
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(white: 0.7, alpha: 1.0)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes

            // Selected state
            let selectedAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(red: 0.27, green: 0.84, blue: 0.46, alpha: 1.0)
            ]
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 0.27, green: 0.84, blue: 0.46, alpha: 1.0)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes

            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }

    private func setupViewControllers() {
        // Trips Tab
        let tripsVC = TripsViewController()
        tripsVC.tabBarItem = UITabBarItem(
            title: "Trips",
            image: UIImage(systemName: "car"),
            selectedImage: UIImage(systemName: "car.fill")
        )

        // Profile Tab
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.circle"),
            selectedImage: UIImage(systemName: "person.circle.fill")
        )

        // For now, we'll just show these two tabs
        // Additional tabs (Leaders, Dashboard, My Rewards) can be added later
        viewControllers = [tripsVC, profileVC]
    }
}
