//
//  WeatherModel.swift
//  Clima
//
//  Created by Samed Karakuş on 15.08.2024.
//

import Foundation

//Weatherdata içerisine decode ettiğimiz verileri burada depolayacağız ki kullanabilelim.

struct WeatherModel {
    let cityName: String
    let temperature: Double
    let description: String
    let conditionID: Int
    let maxTemperature: Double
    let minTemperature: Double
    
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    var conditionName: String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt.rain.fill"
        case 300...321:
            return "cloud.drizzle.fill"
        case 500...531:
            return "cloud.rain.fill"
        case 600...622:
            return "cloud.snow.fill"
        case 701...781:
            return "cloud.fog.fill"
        case 800:
            return "sun.max.fill"
        case 801...804:
            return "cloud.bolt.fill"
        default:
            return "cloud"
        }
    }
}
