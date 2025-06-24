//
//  WeatherModel.swift
//  ForecastFiesta
//
//  Created by Rohin Madhavan on 28/04/2024.
//

import Foundation

struct WeatherModel {
    let id: Int
    let cityName: String
    let temperature: Double
    
    var tempString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    var conditionAnimation: String {
        switch id {
        case 200...232:
            return "bolt"
        case 300...321:
            return "cloud-drizzle"
        case 500...531:
            return "bolt-rain"
        case 600...622:
           return "cloud-snows"
        case 701...781:
            return "fog"
        case 800:
            return "sun"
        case 801...804:
            return "bolt"
        default:
            return "cloud"
        }
    }
}
