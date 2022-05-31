
   
//
//  ContentView.swift
//  PetStoreSwiftUI
//
//  Created by Leila Nezaratizadeh on 11/04/2022.
//
import SwiftUI

struct ContentView1: View {
    @EnvironmentObject var pets: Pets
    @State var ShowingAddPetpage : Bool = false
    @State var statusValue:String = ""
    @State var pet : Pet = Pet()
    
    
    var body: some View {
//        VStack {
//            StatusDropDownView(statusValue: $statusValue)
            
            NavigationView {
                List {
                    StatusDropDownView(statusValue: $statusValue)

                    ForEach(pets.petCashes) { pet in
                        NavigationLink(destination: DetailView(pet: pet,pets: _pets, statusValue: $statusValue)) {
                        Text(pet.name ?? "no name")
                        }
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                    
                }
                .refreshable {
                    print("refresh table")
                    print(statusValue)
                    APIService.loadData(status: statusValue, pets: pets)
                }
                .listStyle(.inset)
                .navigationTitle("Pets")
                .navigationBarItems(leading: Button(action: {
                    ShowingAddPetpage = true
                    
                }, label: {
                    Image(systemName: "plus")
                })
                                        .disabled(statusValue == "")
                                        .sheet(isPresented: $ShowingAddPetpage, onDismiss: {
                    
                }) {
                    NewPetView(statusValue:$statusValue, pet: $pet)
                }
                                    , trailing:EditButton())
//            }
            
            
            //            List(pets,id:\.id) { pet in
            //                Text(pet.name ?? "no name")
            //            }
        }
    }
    
    
    
    func move(from source: IndexSet, to destination: Int) {
        pets.petCashes.move(fromOffsets: source, toOffset: destination)
    }
    
    func delete(at offsets: IndexSet) {
        for i in offsets.makeIterator() {
            let petId = pets.petCashes[i].id
            guard let url = URL(string: "https://petstore.swagger.io/v2/pet/\(petId)") else {
                print("Error: cannot create URL")
                return
            }
            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("Error: error calling DELETE")
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
                        print("Error: Cannot convert data to JSON")
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
                    
                    print(prettyPrintedJson)
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }.resume()
            
            
            
        }
        pets.petCashes.remove(atOffsets: offsets)
        
    }
}


struct ContentView_Previews1: PreviewProvider {
    static var previews: some View {
        ContentView1()
            .environmentObject(Pets())
    }
}

struct StatusDropDownView1: View {
    var statusDropDownList = ["sold", "available", "pending"]
    var placeholder = "Status"
    @Binding var statusValue : String
    @EnvironmentObject var pets: Pets
    
    var body: some View {
        Menu {
            ForEach(statusDropDownList, id: \.self){ status in
                Button(status) {
                    self.statusValue = status
                    
                    APIService.loadData(status:statusValue, pets:pets)
                }
            }
        } label: {
            VStack(spacing: 5){
                HStack{
                    Text(statusValue.isEmpty ? placeholder : statusValue)
                        .foregroundColor(statusValue.isEmpty ? .gray : .black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color.blue)
                        .font(Font.system(size: 20, weight: .bold))
                }
                .padding(.horizontal)
                Rectangle()
                    .fill(Color.blue)
                    .frame(height: 2)
            }
        }
        .padding()
    }
    
    
}

