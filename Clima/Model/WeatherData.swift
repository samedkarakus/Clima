//
//  WeatherData.swift
//  Clima
//
//  Created by Samed Karakuş on 15.08.2024.
//

import Foundation

//API ile bağlantı kurup verileri çekeceğimiz alan, Model içerisine burdaki veriler ile bağlantı kurarak ilerleme sağlanacak.

struct WeatherData: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let name: String
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}
