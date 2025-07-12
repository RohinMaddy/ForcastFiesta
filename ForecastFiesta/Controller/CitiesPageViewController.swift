//
//  CitiesPageViewController.swift
//  ForecastFiesta
//
//  Created by Rohin Madhavan on 12/07/2025.
//

import UIKit

class CitiesPageViewController: UIPageViewController {

    // MARK: - Properties

    private var cities: [String] = []
    private let pageControl = UIPageControl()
    private var currentIndex = 0

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        setupPageControl()
        loadCities()

        // Show first city on launch, if any
        if let firstVC = viewController(at: 0) {
            setViewControllers([firstVC], direction: .forward, animated: true)
            pageControl.numberOfPages = cities.count
            pageControl.currentPage = 0
        }
    }

    // MARK: - Setup

    private func setupPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.pageIndicatorTintColor = .lightGray

        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // Optional: tap on dots to jump pages
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
    }

    private func loadCities() {
        cities = CityStorageService.shared.loadCities()
    }

    // MARK: - Helpers

    /// Returns WeatherViewController configured for city at index
    private func viewController(at index: Int) -> WeatherViewController? {
        guard index >= 0 && index < cities.count else { return nil }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController else {
            return nil
        }

        vc.cityName = cities[index]
        return vc
    }

    /// Returns the index of the given WeatherViewController in the cities array
    private func indexOf(_ viewController: UIViewController) -> Int? {
        guard let weatherVC = viewController as? WeatherViewController,
              let city = weatherVC.cityName else { return nil }

        return cities.firstIndex(where: { $0.caseInsensitiveCompare(city) == .orderedSame })
    }

    // MARK: - Actions

    @objc private func pageControlTapped(_ sender: UIPageControl) {
        let selectedIndex = sender.currentPage
        guard selectedIndex != currentIndex,
              let vc = viewController(at: selectedIndex) else { return }

        let direction: UIPageViewController.NavigationDirection = selectedIndex > currentIndex ? .forward : .reverse
        currentIndex = selectedIndex
        setViewControllers([vc], direction: direction, animated: true)
    }
}

// MARK: - UIPageViewControllerDataSource

extension CitiesPageViewController: UIPageViewControllerDataSource {

    /// Return the view controller *before* the current one, or nil if none.
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = indexOf(viewController) else { return nil }
        return self.viewController(at: index - 1)
    }

    /// Return the view controller *after* the current one, or nil if none.
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = indexOf(viewController) else { return nil }
        return self.viewController(at: index + 1)
    }
}

// MARK: - UIPageViewControllerDelegate

extension CitiesPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed,
           let visibleVC = viewControllers?.first,
           let index = indexOf(visibleVC) {
            currentIndex = index
            pageControl.currentPage = index
        }
    }
}
