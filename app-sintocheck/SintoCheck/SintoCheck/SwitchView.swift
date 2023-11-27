//
//  SwitchView.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/20/23.
//

import SwiftUI

struct SwitchView : View {
    @State private var selectedTab = 0
    @State var personalizedList : [HealthDataResponse]?
    @State var standardList : [HealthDataResponse]?
    @State var patientData = AuthenticationResponse()
    @State var listEmpty = true
    @State var getSuccessful = false
    
    @State var modifiedItems: Set<String> = []
    
    func loadListData() async throws -> [HealthDataResponse] {
        guard let url = URL(string: "https://sintocheck-backend.vercel.app/trackedHealthData/\(patientData.id)") else {
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
    
    func loadSListData() async throws -> [HealthDataResponse] {
        guard let url = URL(string: "https://sintocheck-backend.vercel.app/healthData") else {
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

        print(healthDataResponse)
        return healthDataResponse
    }
    
    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $selectedTab) {
                    ProfileView(personalizedList: $personalizedList, standardList: $standardList)
                        .tabItem {
                            Image(systemName: "person")
                            Text("Perfil")
                        }
                        .tag(0)
                    
                    AddDataRecordListView(standardList: $standardList, personalizedList: $personalizedList, healthData: HealthDataResponse(id: "", name: "", quantitative: false, patientId: "", rangeMin: 0.0, rangeMax: 0.0, unit: "", tracked: false, createdAt: ""))
                        .tabItem {
                            Image(systemName: "plus")
                            Text("Añadir registro")
                        }
                        .tag(1)
                    
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Configuración")
                        }
                        .tag(2)
                }
                .accentColor(Color(red: 26/255, green: 26/255, blue: 102/255))
            }
            Divider()
                .background(Color(red: 26/255, green: 26/255, blue: 102/255))
                .padding(.top, 650)
            
            .onAppear {
                    selectedTab = 0 // Set the default selected tab to be the profile view
                Task{
                    do {
                        patientData = try getPatientData()
                        let healthData = try await loadListData()
                        personalizedList = healthData
                        let standardHealthData = try await loadSListData()
                        standardList = standardHealthData
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
                }
            }

        }
        }
    }

#Preview {
    SwitchView()
}
