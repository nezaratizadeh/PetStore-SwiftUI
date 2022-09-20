//
//  Pets.swift
//  PetStoreSwiftUI
//
//  Created by Leila Nezaratizadeh on 17/05/2022.
//

import Foundation
import Combine

class Pets : ObservableObject{
    var sortedPets: [Pet] {
        return petCashes
    }
    
    
    
    /// add new Book
     func addNewPet (pet: Pet ) {
         petCashes.insert(pet, at: 0)
        
         
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
    
    @Published var petCashes : [Pet] = []
}

