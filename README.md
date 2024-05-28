# ForecastFiesta

ForecastFiesta is an iOS application designed to provide users with weather information for their current location or any desired location worldwide. The app utilizes the OpenWeather API to fetch accurate weather data and offers a search functionality for users to find weather information for specific locations.

## Features

- **Current Location Weather**: Automatically detects and displays weather information for the user's current location.
- **Search Functionality**: Allows users to search for weather data by entering the name of a city or location.
- **Detailed Weather Information**: Provides weather conditions and temperature for the desired city.
- **Responsive Design**: Built with UIKit to ensure a smooth and responsive user experience on iOS devices.

## Requirements

- iOS 14.0+
- Xcode 14.0+
- Swift 5.0+

## Screenshots

<img width="363" alt="Screenshot 2024-05-28 at 14 39 20" src="https://github.com/RohinMaddy/ForcastFiesta/assets/40590725/47f2e904-aa03-4e1f-963c-3d6315872dbb">

## Installation

1. Clone or download the repository.
2. Open the project in Xcode.
3. Build and run the app on a simulator or a physical device.

## Usage

1. Upon launching the app, ForecastFiesta will attempt to fetch weather data for your current location automatically.
2. If you wish to view weather information for a different location, tap on the search bar at the top of the screen and enter the name of the desired city or location.

## API Key

ForecastFiesta uses the OpenWeather API to fetch weather data. You will need to sign up for an API key from [OpenWeather](https://openweathermap.org/api) and replace the placeholder in the code with your API key.

```swift
let OPEN_WEATHER_API_KEY = "YOUR_API_KEY"
