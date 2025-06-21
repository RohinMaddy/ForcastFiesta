//
//  WeatherManager.swift
//  ForecastFiesta
//
//  Created by Rohin Madhavan on 28/04/2024.
//

import Foundation
import CoreLocation

protocol WeatherManagerProtocol {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
    func updateWeatherBackgroundImage(imageUrl: String)
}

let OPEN_WEATHER_API_KEY = apiKey

struct WeatherManager {
    var delegate: WeatherManagerProtocol?
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather?appid=\(OPEN_WEATHER_API_KEY)&units=metric"
    let pixelUrl = "https://api.pexels.com/v1/"
    private let pageLimit = 1
    
    func fetchWeather(cityName: String) {
        let weatherUrl = "\(baseUrl)&q=\(cityName)"
        processRequest(urlString: weatherUrl)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let weatherUrl = "\(baseUrl)&lat=\(latitude)&lon=\(longitude)"
        processRequest(urlString: weatherUrl)
    }
    
    func processRequest(urlString: String) {
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData  = data {
                    if let weather = self.parseJsonData(data: safeData) {
                        getBackgroundWallpaper(query: weather.cityName)
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func getBackgroundWallpaper(query: String) {
        let endpoint = pixelUrl + "search/?page=\(1)&query=\(query)"
        
        guard let url = URL(string: endpoint) else {
            return
        }
        
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let token = pixelApiKey
        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                self.delegate?.didFailWithError(error: error)
                return
            }
            
            if let data = data {
                do {
                    let pixel = try JSONDecoder().decode(Pixel.self, from: data)
                    self.delegate?.updateWeatherBackgroundImage(imageUrl: pixel.photos[0].src.portrait)
                } catch {
                    self.delegate?.didFailWithError(error: error)
                    return
                }
                
            }
        }
        task.resume()
    }
    
    func parseJsonData(data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let weatherModel = WeatherModel(id: decodedData.weather[0].id, cityName: decodedData.name, temperature: decodedData.main.temp)
            return weatherModel
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

