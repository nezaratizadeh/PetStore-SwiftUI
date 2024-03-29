//
//  AddPet.swift
//  PetStoreSwiftUI
//
//  Created by Leila Nezaratizadeh on 16/05/2022.
//

import SwiftUI

struct NewPetView: View {
    @Binding var statusValue: String
    @State var pet : Pet = Pet()
    @EnvironmentObject var pets: PetsViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("PetName",text: $pet.name.toUnwrapped(defaultValue: "No name"))
                    .disableAutocorrection(true)
                    .textFieldStyle(.roundedBorder)
                    .navigationBarTitle("Got a new Pet")
                
                    .toolbar{
                        ToolbarItem(placement: .status){
                            Button("Add to PetStore"){
                                pet.status = statusValue
                                pets.addNewPet(pet: pet)
                                dismiss()
                            }
                            
                        }
                        
                    }
            }
            .padding()
        }
    }
}

extension Binding {
    func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}

struct NewPetView_Previews: PreviewProvider {
    static var previews: some View {
        NewPetView(statusValue: .constant(""))
            .environmentObject(PetsViewModel())
    }
}
