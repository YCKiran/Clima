//
//  WeatherData.swift
//  Clima
//
//  Created by Chandra Kiran Reddy Yeduguri on 09/03/24.
//

import Foundation

//Decodable is used to decode the JSON Data to swift object
//Encodable is used to encode data from swift object to JSON
//We can use both Encodable to Decodable using Codable which is combination of both
//typealias Codable = Decodable & Encodable
//Codable is a type alias for the combination of both Decodable & Encodable

struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable{
    let temp: Double
}

struct Weather: Codable{
    let id: Int
    let main: String
    let description: String
}


