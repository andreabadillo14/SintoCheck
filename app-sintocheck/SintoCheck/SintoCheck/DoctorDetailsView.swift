//
//  DoctorDetailsView.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 10/20/23.
//

import SwiftUI

struct Doctor: Codable, Identifiable {
    let id: String
    let name: String
    let phone: String
    let speciality: String?
}

func fetchDoctor(completion: @escaping ([Doctor]?) -> Void) {
    guard let url = URL(string: "https://sintocheck-backend.vercel.app/doctorPatientRelationship/654ea09fd9fb791b4b7f087c") else {return}
    var request = URLRequest(url: url)
    request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1NGVhMDlmZDlmYjc5MWI0YjdmMDg3YyIsIm5hbWUiOiJQYWNpZW50ZSBDZXJvIiwicGhvbmUiOiIwOTg3NjU0MzIxIiwiaWF0IjoxNjk5NjUxODE4LCJleHAiOjE3MDA4NjE0MTh9.Z_WvGy2TCsvFr9_eW_V3ModNnupaUr1_B9QtNG7I97A", forHTTPHeaderField: "Authorization")
    request.httpMethod = "GET"

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
        }
        if let response = response {
            print("Response: \(response)")
        }
        if let data = data {
            do {
                let decoder = JSONDecoder()
                let doctoresAPI = try decoder.decode([Doctor].self, from: data)
                print("Data: \(doctoresAPI)")
                completion(doctoresAPI)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }
    }.resume()
}


struct DoctorDetailsView: View {
    @State var doctors: [Doctor]?
    @State var doctorVacia: [Doctor] = []
    var body: some View {
        //Recibir una lista de DoctorDetails y para cada uno generar un InfoDoctor
//        let doctors: [DoctorDetails] = [
//                DoctorDetails(id: UUID(), name: "Astrid", lastname: "Serna", birthdate: "01/01/1980", height: 175.0, weight: 70.0, medicine: "Cardiología", medicalBackground: "Cardiología"),
//                DoctorDetails(id: UUID(), name: "Paula", lastname: "Salinas", birthdate: "02/02/1990", height: 165.0, weight: 60.0, medicine: "Dermatología", medicalBackground: "Dermatología"),
//                DoctorDetails(id: UUID(), name: "Juan", lastname: "Perez", birthdate: "03/03/1985", height: 180.0, weight: 80.0, medicine: "Neurología", medicalBackground: "Neurología")
//            ]
        
        NavigationView {
            
            VStack(spacing:50) {
                List (doctors ?? doctorVacia) { doctor in
                    InfoDoctor(name: doctor.name,  medicalBackground: doctor.speciality ?? "", phoneNumber: doctor.phone)
                    }
                    
                   

                }.listStyle(.sidebar)
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                .background(Color.clear)
                Spacer()
                
            }
            .navigationTitle("Doctores registrados")
            .onAppear(perform: {
                fetchDoctor { doctors in
                    self.doctors = doctors
                }
            })
        }
        
}




struct DoctorDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorDetailsView()
    }
}
