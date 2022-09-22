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
         APIService.apiService.addPet(pet: pet)
        
         
    }
    
    @Published var petCashes : [Pet] = []
}

