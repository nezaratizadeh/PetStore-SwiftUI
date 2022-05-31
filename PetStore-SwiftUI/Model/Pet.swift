//
//  Pet.swift
//  PetStoreSwiftUI
//
//  Created by Leila Nezaratizadeh on 13/04/2022.
//

import Foundation
import Combine

class Pet: Codable , ObservableObject {
    
    var id: UInt64
    var name: String?
    var status: String?
    var tags: [Tag]?
    var category: Category?
    var photoUrls: [String]?
    
    init(id: UInt64 = 0 , name: String = "", status:String = "sold", tags:[Tag] = [], photoUrls:[String] = []) {
        self.id = id
        self.name = name
        self.status = status
        self.tags = tags
        self.photoUrls = photoUrls
    }
    
}

extension Pet: Equatable {
    static func == (lhs: Pet, rhs: Pet) -> Bool {
        lhs === rhs
    }

}


extension Pet: Hashable,Identifiable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

