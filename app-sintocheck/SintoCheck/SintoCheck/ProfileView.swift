//
//  ProfileView.swift
//  perfil-SintoCheck
//
//  Created by Andrea Badillo
//on 10/16/23.
//

import SwiftUI
import PhotosUI

struct ImageAPI: Codable, Equatable {
    let url: String
}


struct ProfileView: View {
    @State var patientData : AuthenticationResponse?
    @Binding var personalizedList : [HealthDataResponse]?
    @Binding var standardList : [HealthDataResponse]?
    //@State var APatient : PatientSignupRequest
    
//    var patients = [
//        Patient(id: UUID(), name: "Hermenegildo", lastname: "Pérez", birthdate: "1945-03-25", height: 1.78, weight: 65.4, medicine: "Vitaminas de calcio", medicalBackground: "Genética de diabetes")
//    ]
    @State var seRegistroDoctor = false
    @State var mensajeEnlace = ""
    @State var showPhotosPicker: Bool = false
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var url:ImageAPI?

    
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
                            
                            
//                            HStack(alignment: .center) {
//                                Image(systemName: "person.circle.fill")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 73)
//                                    .padding(.leading, -60)
//                                
//                                VStack(alignment: .leading) {
//                                    if let patientData = patientData{
//                                        Text("\(patientData.name)")
//                                        Text("\(patientData.phone)")
//                                    }
//                                }
//                                .padding(.leading)
//                                
//                            }
                            HStack(alignment: .center) {
                                Menu {
                                    Button("Cambiar foto de perfil") {
                                        showPhotosPicker = true
                                    }
                                } label: {
                                    if let url = url {
                                        AsyncImage(url: URL(string: url.url)) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 100, height: 100)
                                                .clipShape(.circle)
                                        } placeholder: {
                                            Image(uiImage: (UIImage(systemName: "person.crop.circle.fill"))!)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 100, height: 100)
                                                .clipShape(.circle)
                                        }
                                        
                                    } else {
                                        Image(uiImage: (UIImage(systemName: "person.crop.circle.fill"))!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 100)
                                            .clipShape(.circle)
                                    }
                                    
                                }.foregroundColor(Color.black)
                                
                                
                                VStack(alignment: .leading) { // esto sigue hardcordeado
                                    if let patientData = patientData{
                                        Text("\(patientData.name)")
                                        Text("\(patientData.phone)")
                                    }
                                }
                                .padding(.leading)
                                Spacer()
                            }.padding(.leading, 20)
                            
                            
                            
                            
                            Spacer()
                            
                            Section {
                                List {
                                    NavigationLink(destination: MedicalDataView()) {
                                    Image(systemName: "aqi.medium")
                                        .foregroundColor(Color(red: 148/255, green: 28/255, blue: 47/255))
                                    Text("Detalles personales médicos")
                                }
                                    NavigationLink(destination: HealthDataDetails(personalizedList: $personalizedList, standardList: $standardList)) {
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
                                    NavigationLink(destination: MedicalLinkView(exito: $seRegistroDoctor, mensajeLink: $mensajeEnlace)) {
                                        Image(systemName: "person.crop.circle.badge.plus")
                                            .foregroundColor(Color(red: 26/255, green: 26/255, blue: 102/255))
                                        Text("Enlazar a un médico")
                                    }
                                    
                                }
                                
                            }
                            
                            Spacer(minLength: 175)
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
                    //obtener el url del endpoint para paciente luego
                    fetchImage() { url in
                        self.url = url
                    }
                }
                .background(Color.clear)
                .alert("\(mensajeEnlace)", isPresented: $seRegistroDoctor, actions: {})
                .photosPicker(isPresented: $showPhotosPicker, selection: $photosPickerItem, matching: .images)
                .onChange(of: photosPickerItem) { _, _ in
                    Task {
                        if let photosPickerItem,
                           let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                            if let image = UIImage(data: data) {
                                sendImage(image: image) {
                                    fetchImage() { url in
                                        DispatchQueue.main.async {
                                                self.url = url
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                //.navigationTitle("Mi perfil")
                //            .task {
                //                await getMedicalData()
            }
            
        }
        
    }
}


struct ProfileView_Previews: PreviewProvider {
    @State static var previewHealthData: [HealthDataResponse]? = [
        HealthDataResponse(id: "6525e53c250bcddf903d32d5", name: "Tos", quantitative: false, patientId: "1", rangeMin: 1, rangeMax: 10, unit: "", tracked: false, createdAt: ""),
        HealthDataResponse(id: "6525e53c250bcddf903d32d5", name: "Tos", quantitative: false, patientId: "1", rangeMin: 1, rangeMax: 10, unit: "", tracked: false, createdAt: "")
    ]
    
    static var previews: some View {
        ProfileView(personalizedList: $previewHealthData, standardList: $previewHealthData)
    }
}

//#Preview {
//    ProfileView()
//}
