//
//  ViewController.swift
//  Clima
//
//  Created by Samed Karakuş on 8.08.2024.
//

import UIKit
import CoreLocation

//MARK: - UIViewController

class WeatherViewController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var locationTextFieldView: UIStackView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var isKeyboardVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation() //Anlık konumu günceller.
        //locationManager.startUpdatingLocation() //Her saniye konumu günceller.
        
        //Delegate edilenleri SELF etmeyi unutma!!!
        weatherManager.delegate = self
        searchTextField.delegate = self

        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        paddingView.addSubview(imageView)

        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = .always
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard !isKeyboardVisible else { return }

        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardSize.cgRectValue
            let keyboardHeight = keyboardFrame.height
            
            let textFieldYPosition = locationTextFieldView.frame.origin.y
            let offset = textFieldYPosition - (self.view.frame.height - keyboardHeight - locationTextFieldView.frame.height - 10)
            
            if offset > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.locationTextFieldView.transform = CGAffineTransform(translationX: 0, y: -offset)
                }
            }
            isKeyboardVisible = true
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.locationTextFieldView.transform = .identity
        }
        isKeyboardVisible = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - Double

extension Double {
    func round(to places: Int) -> Double {
        let precisionNumber = pow(10, Double(places))
        var n = self
        n = n * precisionNumber
        n.round()
        n = n / precisionNumber
        return n
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            searchTextField.placeholder = "Bir şey yaz..."
            return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = searchTextField.text, !cityName.isEmpty {
            weatherManager.fetchWeather(cityName: cityName)
        } else {
            searchTextField.placeholder = "Geçerli bölge ismi gir..."
        }
        searchTextField.text = ""
    }

}

//MARK: - WeatherModelDelegate

extension WeatherViewController: WeatherManagerDelegate {

    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async { [self] in
            cityLabel.text = weather.cityName
            temperatureLabel.text = weather.temperatureString + "°"
            conditionImageView.image = UIImage(systemName: weather.conditionName)
            conditionLabel.text = weather.description.capitalized
            maxTempLabel.text = "Y: " + String(weather.maxTemperature.round(to: 1)) + "°C"
            minTempLabel.text = "D: " + String(weather.minTemperature.round(to: 1)) + "°C"
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func updateBackgroundImage() {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 6 && hour < 18 {
            backgroundImageView.image = UIImage(named: "MorningBackground")!
        } else {
            backgroundImageView.image = UIImage(named: "NightBackground")!
        }
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                print("Location is currently unknown, but CLLocationManager will keep trying.")
                // Kullanıcıya bilgilendirme mesajı göster.
                showAlert(title: "Location Error", message: "Unable to determine your location right now. We'll keep trying!")
            case .denied:
                print("Permission to access location was denied.")
                showAlert(title: "Location Permission Denied", message: "Please enable location permissions in Settings.")
            case .network:
                print("Network-related error occurred.")
                showAlert(title: "Network Error", message: "A network error occurred while trying to get your location. Please check your connection.")
            default:
                print("Other Core Location error occurred.")
                showAlert(title: "Location Error", message: "An unknown error occurred. Please try again later.")
            }
        }
    }

    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
