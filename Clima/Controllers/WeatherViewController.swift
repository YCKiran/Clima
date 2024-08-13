//
//  ViewController.swift
//  Clima
//
//  Created by Chandra Kiran Reddy Yeduguri on 24/02/24.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        //Whenever your are extending a protocal make sure you have to set the delegate to point current class
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func fetchCurrentLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}


//MARK: - UITextFieldDelegate

//Created a extension for weatherVC and extends to text field delegate
extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        // print(searchTextField.text!)
        //endEditing will notifies the keyboard to close
        searchTextField.endEditing(true)
    }
    
    //Particular textField will call this method when the associated keyboard go/return button is tapped.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print(searchTextField.text!)
        //endEditing will notifies the keyboard to close
        searchTextField.endEditing(true)
        return true
    }
    
    //This method Asks the delegate whether to stop editing in the specified text field.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //Using this condition we are making the text field to not move away by without entring text.
        if textField.text != ""{
            return true
        } else {
            textField.placeholder = "Type Something"
            return false
        }
    }
    
    //This method will trigger once enter text and move out of the button
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let cityName = searchTextField.text {
            weatherManager.fetchWeather(cityName: cityName)
        }
        
        //This will remove the content typed in text field to empty.
        searchTextField.text = ""
    }
    
}

//MARK: - WeatherManagerDelegate

//Created a extension for weatherVC and extends to weather manager delegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        //print(weather.temperatureString)
        DispatchQueue.main.async(){
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

//Created a extension for weatherVC and extends to CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        print("Got user Location")
        //        print(locations)
        //        print(locations.count)
        //        print(locations.last?.coordinate)
        if let lastLoc = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = lastLoc.coordinate.latitude
            let lon = lastLoc.coordinate.longitude
            //            print(lat)
            //            print(lon)
            weatherManager.fetchWeather(Latitude: lat, Longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


//Without using extensions
//class ViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {
//
//    @IBOutlet weak var conditionImageView: UIImageView!
//    @IBOutlet weak var searchTextField: UITextField!
//    @IBOutlet weak var temperatureLabel: UILabel!
//    @IBOutlet weak var cityLabel: UILabel!
//
//    var weatherManager = WeatherManager()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        weatherManager.delegate = self
//        searchTextField.delegate = self
//    }
//
//    @IBAction func searchButtonPressed(_ sender: UIButton) {
//       // print(searchTextField.text!)
//        //endEditing will notifies the keyboard to close
//        searchTextField.endEditing(true)
//    }
//
//    //Particular textField will call this method when the associated keyboard go/return button is tapped.
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        //print(searchTextField.text!)
//        //endEditing will notifies the keyboard to close
//        searchTextField.endEditing(true)
//        return true
//    }
//
//    //This method Asks the delegate whether to stop editing in the specified text field.
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        //Using this condition we are making the text field to not move away by without entring text.
//        if textField.text != ""{
//            return true
//        } else {
//            textField.placeholder = "Type Something"
//            return false
//        }
//    }
//
//    //This method will trigger once enter text and move out of the button
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//        if let cityName = searchTextField.text {
//            weatherManager.fetchWeather(cityName: cityName)
//        }
//
//        //This will remove the content typed in text field to empty.
//        searchTextField.text = ""
//    }
//
//    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
//        //print(weather.temperatureString)
//        DispatchQueue.main.async(){
//            self.temperatureLabel.text = weather.temperatureString
//            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
//        }
//
//
//    }
//
//    func didFailWithError(error: Error) {
//        print(error)
//    }
//
//}
//
