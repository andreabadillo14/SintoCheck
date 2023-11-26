//
//  ModifyHealthDataListView.swift
//  SintoCheck
//
//  Created by Alumno on 21/11/23.
//

import SwiftUI

struct ModifyHealthDataListView: View {
    @State var listEmpty = true
    let amarillo = Color(red: 246/255, green: 226/255, blue: 127/255)
    @State var patientData = AuthenticationResponse()
    @State var healthData : HealthDataResponse
    
    @Binding var standardList : [HealthDataResponse]?
    @Binding var personalizedList : [HealthDataResponse]?
    
    @State var personalizedRecords : [HealthDataResponse]?
    
    @State var getSuccessful = false
    @State var showErrorAlert = false
    @State var registerSuccessful = false
    
    @State var backView = false
    
    @State var combinedList: [HealthDataResponse] = []

    
    enum FileReaderError: Error {
        case fileNotFound
        case fileReadError
    }
    
    
    // Función para combinar y eliminar duplicados
    func combineAndRemoveDuplicates() {
        var combined = [HealthDataResponse]()

        if let standardList = standardList {
            combined.append(contentsOf: standardList)
        }

        if let personalizedRecords = personalizedRecords {
            for record in personalizedRecords where !combined.contains(where: { $0.name == record.name }) {
                combined.append(record)
            }
        }

        combinedList = combined
    }

    func handleStarTap(for tappedHealthData: HealthDataResponse) {
        if let index = personalizedList?.firstIndex(where: {
            $0.name == tappedHealthData.name }) {
            // Si la estrella está rellena, cambiar a no rellena y llamar a untrackHealthData
            DispatchQueue.main.async {
                self.personalizedList?.remove(at: index)
            }
            combineAndRemoveDuplicates()
            Task {
                do {
                    _ = try await untrackHealthData(healthDataToUntrack: tappedHealthData)
                } catch {
                    print("Error: \(error)")
                }
            }
        } else {
            // Si la estrella no está rellena, cambiar a rellena y llamar a postHealthData o trackHealthData
            DispatchQueue.main.async {
                       self.personalizedList?.append(tappedHealthData)
                   }
            combineAndRemoveDuplicates()
            Task {
                do {
                    if standardList?.contains(where: { $0.name == tappedHealthData.name }) ?? false {
                        // Si es un dato estándar, llamamos a postHealthData
                        _ = try await postHealthData(healthDataToPost: tappedHealthData)
                    } else {
                        // Si no, llamamos a trackHealthData
                        _ = try await trackHealthData(healthDataToTrack: tappedHealthData)
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }




    // Función para determinar si una estrella debe ser rellena o vacía
    func starImage(for healthData: HealthDataResponse) -> String {
        return personalizedList?.contains(where: { $0.name == healthData.name }) ?? false ? "star.fill" : "star"
    }

    
    func loadListData() async throws -> [HealthDataResponse] {
        guard let url = URL(string: "https://sintocheck-backend.vercel.app/personalizedHealthData/\(patientData.id)") else {
            fatalError("Invalid URL")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(patientData.token, forHTTPHeaderField: "Authorization")
        
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code:", httpResponse.statusCode)
            if httpResponse.statusCode != 200 {
                print("Response Data:", String(data: data, encoding: .utf8) ?? "No data")
                throw FileReaderError.fileReadError
            }
        } else {
            throw FileReaderError.fileReadError
        }
        
        let healthDataResponse = try JSONDecoder().decode([HealthDataResponse].self, from: data)
        
        if healthDataResponse.isEmpty {
            listEmpty = true
        } else{
            listEmpty = false
        }
        print(healthDataResponse)
        return healthDataResponse
    }

    func postHealthData(healthDataToPost: HealthDataResponse) async throws -> HealthDataResponse {
        print("Entre aqui")
        guard let url = URL(string: "https://sintocheck-backend.vercel.app/personalizedHealthData") else { fatalError("Invalid URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let parameters = PersonalizedHealthDataRequest(
            name: healthDataToPost.name,
            quantitative: healthDataToPost.quantitative,
            patientId: patientData.id,
            rangeMin: healthDataToPost.rangeMin ?? 0.0,
            rangeMax: healthDataToPost.rangeMax ?? 0.0,
            unit: healthDataToPost.unit ?? "")
        do {
            print("en el do")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(parameters)
            urlRequest.setValue(patientData.token, forHTTPHeaderField: "Authorization")
        } catch {
            print("Error: \(error)")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code:", httpResponse.statusCode)
                if httpResponse.statusCode != 200 {
                    print("Response Data:", String(data: data, encoding: .utf8) ?? "No data")
                    throw FileReaderError.fileReadError
                }
                
                if httpResponse.statusCode == 200 {
                    healthData = try JSONDecoder().decode(HealthDataResponse.self, from: data)
                    
                    registerSuccessful = true
                }
                
            } else {
                throw FileReaderError.fileReadError
            }
        }catch {
            print("Error: \(error)")
            // If there's an error, show an alert
        }
        return healthData
    }
    
    func trackHealthData(healthDataToTrack: HealthDataResponse) async throws -> HealthDataResponse {
        print("Entre aqui")
        guard let url = URL(string: "https://sintocheck-backend.vercel.app/trackHealthData/\(healthDataToTrack.id)") else { fatalError("Invalid URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        
        do {
            print("en el do")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue(patientData.token, forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code:", httpResponse.statusCode)
                if httpResponse.statusCode != 200 {
                    print("Response Data:", String(data: data, encoding: .utf8) ?? "No data")
                    throw FileReaderError.fileReadError
                }
                
                if httpResponse.statusCode == 200 {
                    healthData = try JSONDecoder().decode(HealthDataResponse.self, from: data)
                    
                    registerSuccessful = true
                }
                
            } else {
                throw FileReaderError.fileReadError
            }
        }catch {
            print("Error: \(error)")
            // If there's an error, show an alert
        }
        return healthData
    }
    
    func untrackHealthData(healthDataToUntrack: HealthDataResponse) async throws -> HealthDataResponse {
        print("Entre aqui")
        guard let url = URL(string: "https://sintocheck-backend.vercel.app/untrackHealthData/\(healthDataToUntrack.id)") else { fatalError("Invalid URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        
        do {
            print("en el do")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue(patientData.token, forHTTPHeaderField: "Authorization")
            print(urlRequest)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code:", httpResponse.statusCode)
                if httpResponse.statusCode != 200 {
                    print("Response Data:", String(data: data, encoding: .utf8) ?? "No data")
                    throw FileReaderError.fileReadError
                }
                
                if httpResponse.statusCode == 200 {
                    healthData = try JSONDecoder().decode(HealthDataResponse.self, from: data)
                    
                    registerSuccessful = true
                }
                
            } else {
                throw FileReaderError.fileReadError
            }
        }catch {
            print("Error: \(error)")
            // If there's an error, show an alert
        }
        return healthData
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color("Backgrounds")
                    .ignoresSafeArea()
                VStack{
                    Text("Modificar Lista")
                        .padding(.top, 40)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 6)
                    if let standardList = standardList, !standardList.isEmpty {
                        List(combinedList, id: \.id) { healthData in
                            HStack {
                                Text(healthData.name)
                                Spacer()
                                Image(systemName: starImage(for: healthData))
                                    .foregroundColor(amarillo)
                                    .onTapGesture {
                                        handleStarTap(for: healthData)
                                    }
                            }
                        }
                        
                    } else {
                        Text("No hay datos disponibles.")
                    }
                    List{
                        NavigationLink(destination: AddPersonalizedHealthDataView(healthData: HealthDataResponse(id: "", name: "", quantitative: false, patientId: "", rangeMin: 0.0, rangeMax: 0.0, unit: "", tracked: false, createdAt: ""), name: "", rangoInferior: "", rangoSuperior: "", unidades: "", rangeMin: 0.0, rangeMax: 0.0, quantitative: false, registerSuccessful: false, showAlert: false, alertTitle: "", alertText: "", selectedOption: .cuantitativo)) { Text("Otro: ") }
                    }
                }
            }
            .navigationBarItems(leading: Button("Regresar"){
                backView = true
            }.fullScreenCover(isPresented: $backView, content: {
                AddDataRecordListView(standardList: $standardList, personalizedList: $personalizedList, healthData: healthData)
                              }))
        }
            .onAppear {
                Task{
                    do {
                        patientData = try getPatientData()
                        personalizedRecords = try await loadListData()
                        getSuccessful = true
                        
                    } catch let error as FileReaderError {
                        print(error)
                        switch error {
                        case .fileNotFound:
                            print("not found")
                        case .fileReadError:
                            print("read error")
                        }
                    } catch {
                        print("unknown: \(error)")
                    }
                    combineAndRemoveDuplicates()
                }
             }
            .background(Color.clear)
        }
    }

struct ModifyHealthDataListView_Previews: PreviewProvider {
    @State static var previewHealthData: [HealthDataResponse]? = [
        HealthDataResponse(id: "6525e53c250bcddf903d32d5", name: "Tos", quantitative: false, patientId: "1", rangeMin: 1, rangeMax: 10, unit: "", tracked: false, createdAt: ""),
        HealthDataResponse(id: "6525e53c250bcddf903d32d5", name: "Tos", quantitative: false, patientId: "1", rangeMin: 1, rangeMax: 10, unit: "", tracked: false, createdAt: "")
    ]

    static var previews: some View {
        ModifyHealthDataListView(healthData: HealthDataResponse(id: "6525e53c250bcddf903d32d5", name: "Tos", quantitative: false, patientId: "1", rangeMin: 1, rangeMax: 10, unit: "", tracked: false, createdAt: ""), standardList: $previewHealthData, personalizedList: $previewHealthData)
    }
}
