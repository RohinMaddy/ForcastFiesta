//
//  CityStorageService.swift
//  ForecastFiesta
//
//  Created by Rohin Madhavan on 12/07/2025.
//

import Foundation

final class CityStorageService {
    static let shared = CityStorageService()

    private init() {}

    private let key = "SavedCities"
    private let defaults = UserDefaults.standard

    func loadCities() -> [String] {
        return defaults.stringArray(forKey: key) ?? []
    }

    func saveCities(_ cities: [String]) {
        defaults.set(cities, forKey: key)
    }

    func addCity(_ city: String) {
        var cities = loadCities()
        guard !cities.contains(where: { $0.caseInsensitiveCompare(city) == .orderedSame }) else { return }
        cities.append(city)
        saveCities(cities)
    }

    func removeCity(_ city: String) {
        var cities = loadCities()
        cities.removeAll { $0.caseInsensitiveCompare(city) == .orderedSame }
        saveCities(cities)
    }

    func clearAllCities() {
        defaults.removeObject(forKey: key)
    }

    func isCitySaved(_ city: String) -> Bool {
        return loadCities().contains { $0.caseInsensitiveCompare(city) == .orderedSame }
    }
}
