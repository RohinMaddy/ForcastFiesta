//
//  WeatherData.swift
//  ForecastFiesta
//
//  Created by Rohin Madhavan on 28/04/2024.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}

