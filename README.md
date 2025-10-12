# ForecastFiesta

ForecastFiesta is an iOS application designed to provide users with weather information for their current location or any desired location worldwide. The app utilizes the OpenWeather API to fetch accurate weather data and offers a search functionality for users to find weather information for specific locations. The App also pulls wallpapers from pexel based on the users current or desired location as well along with weather specific lottie animations. You can also save your favourite locations as well.

## Features

- **Current Location Weather**: Automatically detects and displays weather information for the user's current location.
- **Search Functionality**: Allows users to search for weather data by entering the name of a city or location.
- **Detailed Weather Information**: Provides weather conditions and temperature for the desired city along with fun animations.
- **View Curated Wallpapers**: Allows user to see curated wallpapers using Pixel API.
- **Responsive Design**: Built with UIKit to ensure a smooth and responsive user experience on iOS devices.

## Requirements

- iOS 14.0+
- Xcode 14.0+
- Swift 5.0+

## Screenshots

<img width="300" height="600" alt="simulator_screenshot_1FE891B0-55CF-4C5D-A607-05F33619D66D" src="https://github.com/user-attachments/assets/ce4a9ea3-d4bd-4834-b3d4-555019fe01ea" />
<img width="300" height="600" alt="simulator_screenshot_F5362060-B4F1-45F1-85A7-EB96F7616901" src="https://github.com/user-attachments/assets/f2a3acee-64ba-415b-8937-38c51c997307" />

## Installation


1. Clone or download the repository.
2. Open the project in Xcode.
3. Build and run the app on a simulator or a physical device.

## Usage

1. Upon launching the app, ForecastFiesta will attempt to fetch weather data for your current location automatically.
2. If you wish to view weather information for a different location, tap on the search bar at the top of the screen and enter the name of the desired city or location.
3. Users can save their favourite location as well

## API Key

ForecastFiesta uses the OpenWeather API to fetch weather data. You will need to sign up for an API key from [OpenWeather](https://openweathermap.org/api) and replace the placeholder in the code with your API key. Now it also uses Pixel API to collected curated wallpapers as background along with the ability to save your favourite location.

```swift
let OPEN_WEATHER_API_KEY = "YOUR_API_KEY"
