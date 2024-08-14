//
//  WeatherData.swift
//  Clima
//
//  Created by Samed Karakuş on 15.08.2024.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Weather: Decodable {
    let description: String
}

struct Main: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}
