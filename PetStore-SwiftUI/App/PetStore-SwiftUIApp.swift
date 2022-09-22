//
//  PetStoreSwiftUIApp.swift
//  PetStoreSwiftUI
//
//  Created by Leila Nezaratizadeh on 11/04/2022.
//

import SwiftUI

@main
struct PetStoreSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PetsViewModel())
        }
    }
}
