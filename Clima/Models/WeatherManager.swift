//
//  WeatherManager.swift
//  Clima
//
//  Created by Chandra Kiran Reddy Yeduguri on 04/03/24.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=********API KEY***********&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        //        print(urlString)
        performRequest(urlString)
    }
    
    //    func fetchWeather(Latitude lat: Double, Longitude lon: Double){
    func fetchWeather(Latitude lat: CLLocationDegrees, Longitude lon: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        print(urlString)
        performRequest(urlString)
    }
    
    func performRequest(_ urlString: String) {
        //1. Create URL
        if let url = URL(string: urlString) {
            //2. Create Session
            let session = URLSession(configuration: .default)
            //3. Assign task to session
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. Start task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            //            print(decodedData.name)
            //            print(decodedData.main.temp)
            //            print(decodedData.weather[0].id)
            let weatherId = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let city = decodedData.name
            let weather = WeatherModel(conditionId: weatherId, cityName: city, temperature: temp)
            return weather
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
