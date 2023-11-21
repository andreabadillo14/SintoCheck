//
//  MedicalDataView.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 10/18/23.
//

import SwiftUI

struct MedicalDataView: View {
    //var APatient : Patient
    //var APatient : PatientSignupRequest
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
            patientData = try getPatientData()
        } catch let error as FileReaderError {
            switch error {
            case .fileNotFound:
                print("File not found")
            case .fileReadError:
                print("Error reading file")
            }
        } catch {
            print("An unknown error occurred: \(error)")
        }
    }
    
    
    var body: some View {
        ZStack {
            Color("Backgrounds")
                .ignoresSafeArea()
            VStack {
                Section {
                    Text("Detalles Personales Médicos")
                        .bold()
                        .font(.largeTitle)
                        .padding(.top, 20)
                    List {
                        HStack {
                            Text("Fecha de nacimiento")
                            Spacer()
                            if let patientData = patientData {
                                Text(patientData.birthdate ?? "")
                                    .opacity(0.8)
                            }
                            
                        }
                        
                        HStack {
                            Text("Altura")
                            Spacer()
                            if let patientData = patientData {
                                Text(String(format: "%.2f", patientData.height ?? ""))
                                    .opacity(0.8)
                                Text("cm")
                                    .opacity(0.8)
                            }
                            
                        }
                        
                        HStack {
                            Text("Peso")
                            Spacer()
                            if let patientData = patientData {
                                Text(String(format: "%.1f", patientData.weight ?? ""))
                                Text("kg")
                                    .opacity(0.8)
                            }
                            
                        }
                        
                        HStack {
                            Text("Medicina")
                            Spacer()
                            if let patientData = patientData {
                                Text(patientData.medicine ?? "")
                                    .opacity(0.8)
                            }
                            
                        }
                        
                        HStack {
                            Text("Antecedentes")
                            Spacer()
                            if let patientData = patientData {
                                Text(patientData.medicalBackground ?? "")
                                    .opacity(0.8)
                            }
                            
                        }
                        }
                    }
                }
            }
            .onAppear {
                //Task {
                    handlePatientData()
                //}
            }
        }

    }
//}

struct MedicalDataView_Previews: PreviewProvider {
    static var previews: some View {
//        MedicalDataView(APatient: PatientSignupRequest(name: "Hermenegildo",phone: "81-1234-1234", password: "mundo", birthdate: "1934-04-23", height: 1.65, weight: 0, medicine: "no", medicalBackground: "no"))
        MedicalDataView()
    }
}
