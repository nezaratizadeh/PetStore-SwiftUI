//
//  DetailView.swift
//  PetStore-SwiftUI
//
//  Created by Leila Nezaratizadeh on 30/05/2022.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var pet : Pet
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var pets: Pets
    @Binding var statusValue:String


    var body: some View {
        VStack {
            TextField("name", text: $pet.name.toUnwrapped(defaultValue: "no name"))
            Button("OK") {
                APIService.editPetData(pet: pet)
                APIService.loadData(status: statusValue , pets: pets)
                dismiss()
            }
        }
        .frame( height: 80)
        .background(Color.gray)
        .padding()
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(pet: Pet(), statusValue: .constant(""))
    }
}

