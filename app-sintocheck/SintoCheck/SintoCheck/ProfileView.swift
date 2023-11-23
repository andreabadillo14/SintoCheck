//
//  ProfileView.swift
//  perfil-SintoCheck
//
//  Created by Andrea Badillo on 10/16/23.
//

import SwiftUI

struct ProfileView: View {
    
    @State var patientData : AuthenticationResponse?
    //@State var APatient : PatientSignupRequest
    
//    var patients = [
//        Patient(id: UUID(), name: "Hermenegildo", lastname: "Pérez", birthdate: "1945-03-25", height: 1.78, weight: 65.4, medicine: "Vitaminas de calcio", medicalBackground: "Genética de diabetes")
//    ]
    
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

    
//    func handlePatientData() {
//        do {
//            patientData = try getPatientData()
//        } catch let error as FileReaderError {
//            switch error {
//            case .fileNotFound:
//                print("File not found")
//            case .fileReadError:
//                print("Error reading file")
//            }
//        } catch {
//            print("An unknown error occurred: \(error)")
//        }
//    }
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Color("Backgrounds")
                        .ignoresSafeArea()
                    VStack {
                        VStack {
                            
                            Image("Logo Chiquito")
                                .resizable()
                                .frame(width: 50, height: 50)
 
                            Divider()
                                .background(Color(red: 148/255, green: 28/255, blue: 47/255))
                                .frame(width: .infinity, height: 1)
                                
                            Text("Mi perfil")
                                .bold()
                                .font(.largeTitle)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            
                            HStack(alignment: .center) {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 73)
                                    .padding(.leading, -60)
                                
                                VStack(alignment: .leading) {
                                    if let patientData = patientData{
                                        Text("\(patientData.name)")
                                        Text("\(patientData.phone)")
                                    }
                                }
                                .padding(.leading)
                            }
                            Spacer()
                            
                            Section {
                                List {
                                    NavigationLink(destination: MedicalDataView()) {
                                    Image(systemName: "aqi.medium")
                                        .foregroundColor(Color(red: 148/255, green: 28/255, blue: 47/255))
                                    Text("Detalles personales médicos")
                                }
                                    NavigationLink(destination: HealthDataDetails()) {
                                        Image(systemName: "heart.fill")
                                            .foregroundColor(Color(red: 148/255, green: 28/255, blue: 47/255))
                                        Text("Detalles de datos de salud")
                                    }
                                    
                                }
                                
                            }
                            Section {
                                List {
                                    NavigationLink(destination: DoctorDetailsView()) {
                                        Image(systemName: "book.pages")
                                            .foregroundColor(Color(red: 26/255, green: 26/255, blue: 102/255))
                                        Text("Detalles de médico")
                                    }
                                    NavigationLink(destination: DoctorDetailsView()) {
                                        Image(systemName: "person.crop.circle.badge.plus")
                                            .foregroundColor(Color(red: 26/255, green: 26/255, blue: 102/255))
                                        Text("Enlazar a un médico")
                                    }
                                    
                                }
                                
                            }
                            
                            Spacer(minLength: 195)
                        }
                        .padding()
                        
                        // 124,152,159
                        //.navigationTitle("Mi perfil")
                        //.foregroundColor(Color(red: 124/255, green: 152/255, blue: 159/255))
                        
                    }
                    
                    .background(Color.clear)
                }
                
                .onAppear {
                    handlePatientData()
                }
                .background(Color.clear)
                //.navigationTitle("Mi perfil")
                //            .task {
                //                await getMedicalData()
            }
            
        }
        
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

//#Preview {
//    ProfileView()
//}
