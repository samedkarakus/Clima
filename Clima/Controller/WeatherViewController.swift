//
//  ViewController.swift
//  Clima
//
//  Created by Samed Karakuş on 8.08.2024.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var highLowLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    let weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        
        searchTextField.layer.cornerRadius = 12
        searchTextField.layer.masksToBounds = true

        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))

        imageView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = searchTextField.tintColor

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        paddingView.addSubview(imageView)

        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = .always
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardSize.cgRectValue
            self.view.frame.origin.y = -keyboardFrame.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            searchTextField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        weatherManager.fetchWeather(cityName: searchTextField.text ?? "Error")
        searchTextField.text = ""
    }

}

