//
//  APIService.swift
//  PetStore-SwiftUI
//
//  Created by Leila Nezaratizadeh on 30/05/2022.
//

import Foundation

class APIService {
    
    static func loadData(status: String,pets: Pets) {
        let url = "https://petstore.swagger.io/v2/pet/"
        let configuration = URLSessionConfiguration.default
        
        guard let url = URL(string: "\(url)findByStatus?status=\(status)") else {
            print("Error: cannot create URL")
            return
        }
        // Create the url request
        
        let session = URLSession(configuration: configuration)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                
                let decodedData = try JSONDecoder().decode([Pet].self,
                                                           from: prettyJsonData)
                DispatchQueue.main.async {
                    pets.petCashes = decodedData
    //                self.tableView.reloadData()
                    print(pets.petCashes.count)
                }
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
        
    }

    
    static func editPetData(pet:Pet) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)

        // Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(pet) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        // Create the request
        var request = URLRequest(url: URL(string: "https://petstore.swagger.io/v2/pet/")!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling PUT")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Could print JSON in String")
                    return
                }
                
    //                print(prettyPrintedJson)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
        
        
    }



}
