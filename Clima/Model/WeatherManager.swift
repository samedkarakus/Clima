//
//  WeatherManager.swift
//  Clima
//
//  Created by Samed Karakuş on 11.08.2024.
//

import Foundation
import UIKit
import CoreLocation

//WeatherModel içerisine depoladığımız verileri güncellememiz için bir protocol (sertifika) oluşturduk ki yetkisi olan kullanabilsin.
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1adbdf35bad9b493b905eac558ec849d&units=metric&lang=tr"
    //delegate adı altında yukarıda oluşturulan protokolü atadık.
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }

    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let cityName = decodedData.name
            let temp = decodedData.main.temp
            let desc = decodedData.weather[0].description
            let id = decodedData.weather[0].id
            let maxTemp = decodedData.main.temp_max
            let minTemp = decodedData.main.temp_min
            
            let weather = WeatherModel(cityName: cityName, temperature: temp, description: desc, conditionID: id, maxTemperature: maxTemp, minTemperature: minTemp)
            
            return weather
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
