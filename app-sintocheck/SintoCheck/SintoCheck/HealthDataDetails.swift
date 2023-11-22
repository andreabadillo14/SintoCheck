//
//  HealthDataDetails.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 10/17/23.
//

import SwiftUI

struct HealthDataDetails: View {
    
    @State var patientData : AuthenticationResponse?
    
    enum FileReaderError: Error {
        case fileNotFound
        case fileReadError
    }
    
    func getPatientData() throws -> AuthenticationResponse {
        // Retrieve the file URL
        let sandboxURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = sandboxURL.appendingPathComponent("loginResponse.json")
        
        // Check if the file exists
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: fileURL.path) {
            // File does not exist, handle this case accordingly
            fatalError("Could not find login response file")
        }
        
        // Read the file contents
        if let data = fileManager.contents(atPath: fileURL.path) {
            // Decode the JSON data into a PatientSignupResponse object
            let decodedData = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
            return decodedData
        } else {
            // Handle the error if the file cannot be read
            //fatalError("Error reading login response file")
            
            throw FileReaderError.fileNotFound        }
    }
    
    func handlePatientData() {
        do {
            let sandboxURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = sandboxURL.appendingPathComponent("loginResponse.json")

            if !FileManager.default.fileExists(atPath: fileURL.path) {
                // File does not exist, handle this case accordingly
                print("Login response file not found")
                return
            }

            patientData = try getPatientData()
        } catch let error {
            print("An error occurred while retrieving patient data: \(error)")
        }
    }
    
    var healthData = [
        PersonalizedHealthDataRequest(id: UUID(), name: "Tos", quantitative: false, patientId: 1, rangeMin: 1, rangeMax: 10, unit: "n/a"),
        PersonalizedHealthDataRequest(id: UUID(), name: "Fiebre", quantitative: true, patientId: 1, rangeMin: 35, rangeMax: 42, unit: "C"),
        PersonalizedHealthDataRequest(id: UUID(), name: "Glucosa", quantitative: true, patientId: 1, rangeMin: 80, rangeMax: 150, unit: "mg/dL")
    ]
    
    
    var body: some View {
        ZStack {
            Color("Backgrounds")
                .ignoresSafeArea()
            VStack {
                Section {
                    Text("Datos de salud")
                        .bold()
                        .font(.largeTitle)
                        .padding(.top, 20)
                }
                
                List(healthData) { data in
                    NavigationLink {
                        HealthDataDetailView(AHealthData: data)
                    } label: {
                        Cell(oneHealthData: data)
                    }
                }
            }
//            .onAppear {
//                handlePatientData()
//            }
        }
    }
}

struct Cell: View {
    var oneHealthData : PersonalizedHealthDataRequest
    
    var body: some View {
        VStack {
            Text(oneHealthData.name)
        }
    }
}

struct HealthDataDetails_Previews: PreviewProvider {
    static var previews: some View {
        HealthDataDetails()
    }
}
