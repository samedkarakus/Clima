//
//  WeatherManager.swift
//  Clima
//
//  Created by Samed Karakuş on 11.08.2024.
//

import Foundation

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1adbdf35bad9b493b905eac558ec849d&units=metric&lang=tr"
    
    func fetchWeather (cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
    }
}
