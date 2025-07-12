//
//  CitiesPageViewController.swift
//  ForecastFiesta
//
//  Created by Rohin Madhavan on 12/07/2025.
//

import UIKit
import CoreLocation

class CitiesPageViewController: UIPageViewController {

    // MARK: - Properties

    private var cities: [String] = []
    private let pageControl = UIPageControl()
    private var currentIndex = 0
    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
    var weatherLoadingOverlay: WeatherLoadingOverlay?
    var currentCity: String?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        dataSource = self
        delegate = self
        
        weatherManager.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCitiesChanged), name: .citiesDidUpdate, object: nil)

        setupPageControl()
    }
    
    @objc private func handleCitiesChanged() {
        reloadCitiesAndPages()
    }
    
    private func showPages() {
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

    private func indexOf(_ viewController: UIViewController) -> Int? {
        guard let weatherVC = viewController as? WeatherViewController,
              let city = weatherVC.cityName else { return nil }

        return cities.firstIndex(where: { $0.caseInsensitiveCompare(city) == .orderedSame })
    }
    
    private func loadCities() {
        if let currentCity {
            cities.removeAll()
            cities.append(currentCity)
            self.cities.append(contentsOf: CityStorageService.shared.loadCities())
        }
    }
    
    func reloadCitiesAndPages() {
        // Reload cities
        loadCities()
        
        pageControl.numberOfPages = cities.count

        // Reset to first page
        if let firstVC = viewController(at: 0) {
            setViewControllers([firstVC], direction: .forward, animated: true)
            pageControl.currentPage = 0
            currentIndex = 0
        }
    }

    @objc private func pageControlTapped(_ sender: UIPageControl) {
        let selectedIndex = sender.currentPage
        guard selectedIndex != currentIndex,
              let vc = viewController(at: selectedIndex) else { return }

        let direction: UIPageViewController.NavigationDirection = selectedIndex > currentIndex ? .forward : .reverse
        currentIndex = selectedIndex
        setViewControllers([vc], direction: direction, animated: true)
    }
}

extension CitiesPageViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alert = UIAlertController(title: "Error", message: "Failed to get location: \(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

extension CitiesPageViewController: WeatherManagerProtocol {
    
    func updateWeatherBackgroundImage(imageUrl: String) {
    }
    
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.currentCity = weather.cityName
            self.loadCities()
            self.showPages()
        }
    }
    
    func didFailWithError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "Failed to weather data: \(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

// MARK: - UIPageViewControllerDataSource

extension CitiesPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = indexOf(viewController) else { return nil }
        return self.viewController(at: index - 1)
    }

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

extension Notification.Name {
    static let citiesDidUpdate = Notification.Name("citiesDidUpdate")
}
