//
//  ViewController.swift
//  ForecastFiesta
//
//  Created by Rohin Madhavan on 28/04/2024.
//

import UIKit
import CoreLocation
import Lottie

class WeatherViewController: UIViewController {

    
    @IBOutlet weak var weatherAnimationView: LottieAnimationView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var saveLocationButton: UIButton!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var weatherLoadingOverlay: WeatherLoadingOverlay?
    
    var cityName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        
        addBlurBackground(to: searchView, style: .systemUltraThinMaterialDark)
        searchView.roundCorners(radius: 20)
        
        addBlurBackground(to: labelView, style: .systemUltraThinMaterialDark)
        labelView.roundCorners(radius: 20)
        
        showWeatherLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let cityName {
            weatherManager.fetchWeather(cityName: cityName)
            if CityStorageService.shared.isCitySaved(cityName) {
                saveLocationButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                saveLocationButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }

    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        locationManager.requestLocation()
        showWeatherLoading()
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        if searchTextField.text == "" || searchTextField.text?.isEmpty ?? true {
            let alert = UIAlertController(title: "Error", message: "Enter location", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        } else {
            if let city = searchTextField.text {
                self.showWeatherLoading()
                weatherManager.fetchWeather(cityName: city)
                searchTextField.endEditing(true)
            }
        }
    }
    
    func addBlurBackground(to view: UIView, style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 0)
    }

    func showWeatherLoading() {
        weatherLoadingOverlay = WeatherLoadingOverlay(frame: view.bounds)
        if let overlay = weatherLoadingOverlay {
            view.addSubview(overlay)
        }
    }

    func hideWeatherLoading() {
        weatherLoadingOverlay?.stop()
        weatherLoadingOverlay = nil
    }
    
    func loadWeatherAnimation(path: String) {
        if let path = Bundle.main.path(forResource: path, ofType: "lottie") {
            let url = URL(fileURLWithPath: path)
            DotLottieFile.loadedFrom(url: url) { result in
                guard case Result.success(let lottie) = result else { return }
                
                self.weatherAnimationView.loadAnimation(from: lottie)
                self.weatherAnimationView.loopMode = .loop
                self.weatherAnimationView.play()
            }
        }
    }

    @IBAction func saveLocationButtonClicked(_ sender: Any) {
        if let cityName = cityLabel.text {
            if CityStorageService.shared.isCitySaved(cityName) {
                CityStorageService.shared.removeCity(cityName)
                saveLocationButton.setImage(UIImage(systemName: "heart"), for: .normal)
            } else {
                CityStorageService.shared.addCity(cityName)
                saveLocationButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        hideWeatherLoading()
        let alert = UIAlertController(title: "Error", message: "Failed to get location: \(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

extension WeatherViewController: WeatherManagerProtocol {
    
    func updateWeatherBackgroundImage(imageUrl: String) {
        guard let url = URL(string: imageUrl) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.backgroundImage.image = image
                    self.hideWeatherLoading()
                }
            }
        }.resume()
    }
    
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempString
            self.cityLabel.text = weather.cityName
            self.loadWeatherAnimation(path: weather.conditionAnimation)
            self.cityName = weather.cityName
            if CityStorageService.shared.isCitySaved(weather.cityName) {
                self.saveLocationButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                self.saveLocationButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }
    
    func didFailWithError(error: Error) {
        hideWeatherLoading()
        let alert = UIAlertController(title: "Error", message: "Failed to weather data: \(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let city = searchTextField.text {
            self.showWeatherLoading()
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextField.text = ""
    }
}
