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
func sendImage(image: UIImage, completion: @escaping () -> Void) {
    guard let url = URL(string: "https://api-text.vercel.app/image") else { return }
    let boundary = UUID().uuidString
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    // Add Authorization Header
    request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1NWQyZTY1ZmUyMmVmNjViODNjOTRlMCIsIm5hbWUiOiJwYWNpZW50ZSBQcnVlYmEiLCJwaG9uZSI6IjEyMzQ0MzIxIiwiaWF0IjoxNzAwNjA1NTUwLCJleHAiOjE3MDE4MTUxNTB9.54PgoD0Vd8xLPWltOAXSDW7iCJGFaRUo-TQANmrPw9k", forHTTPHeaderField: "Authorization")
    
//    // Add Body
//    let patientId = "655bfeae88807f60971b9d27"
//    let bodyData = "patientId=\(patientId)".data(using: .utf8)
    
    // Set Content-Type and Boundary for multipart/form-data
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    var body = Data()
    //agrego el id del paciente
    body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"patientId\"\r\n\r\n".data(using: .utf8)!)
    body.append("655d2e65fe22ef65b83c94e0".data(using: .utf8)!)
    
    //agrego la imagen
    body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"image\"; filename=\"seb.jpg\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
    
    if let imageData = image.jpegData(compressionQuality: 0.99) {
        body.append(imageData)
    }
    
    body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
    
    request.httpBody = body
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if error == nil, let data = data {
            if let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                if let json = jsonData as? [String: Any] {
                    print(json)
                    
                }
            }
        }
        completion() // Call completion on success

    }.resume()
}

//cuando image url este en el api borrar esto y obtener el url del api
func fetchImage(completion: @escaping (ImageAPI?) -> Void) {
    //obtener id del usuario que inicio sesion esta hardcodeado ahora
    guard let url = URL(string: "https://api-text.vercel.app/image") else {return}
    var request = URLRequest(url: url)
    //obtener token del inicio de sesion esta hardcodeado ahora.
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
                let doctoresAPI = try decoder.decode(ImageAPI.self, from: data)
                print("Data: \(doctoresAPI)")
                completion(doctoresAPI)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }
    }.resume()
}

struct ProfileView: View {
    @State var patientData : AuthenticationResponse?
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
                                    NavigationLink(destination: MedicalLinkView(exito: $seRegistroDoctor, mensajeLink: $mensajeEnlace)) {
                                        Image(systemName: "person.crop.circle.badge.plus")
                                            .foregroundColor(Color(red: 26/255, green: 26/255, blue: 102/255))
                                        Text("Enlazar a un médico")
                                    }
                                    
                                }
                                
                            }
                            
                            //                        Section {
                            //                            List {
                            //
                            //
                            //                            }
                            //                        }
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
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
    static var previews: some View {
        ProfileView()
    }
}

//#Preview {
//    ProfileView()
//}
