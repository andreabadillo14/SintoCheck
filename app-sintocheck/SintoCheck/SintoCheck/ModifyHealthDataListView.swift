//
//  ModifyHealthDataListView.swift
//  SintoCheck
//
//  Created by Alumno on 21/11/23.
//

import SwiftUI

struct ModifyHealthDataListView: View {
    @State var listEmpty = true
    
    @State var patientData = AuthenticationResponse()
    @State var standardList : [HealthDataResponse]?
    @State var getSuccessful = false
    @State var showErrorAlert = false
    @State var selectedItems: Set<Int> = [] // Conjunto de IDs seleccionados
    
    enum FileReaderError: Error {
        case fileNotFound
        case fileReadError
    }
    
    func loadListData() async throws -> [HealthDataResponse] {
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
        ZStack{
            Color("Backgrounds")
                .ignoresSafeArea()
            VStack{
                Text("Modificar Lista de Datos")
                    .padding(.top, 20)
                    .font(.largeTitle)
                if let standardList = standardList, !standardList.isEmpty {
                    List(standardList, id: \.id) { healthData in
                        HStack {
                            Text(healthData.name)
                            Spacer()
                            Image(systemName: "star.fill")
                                
                        }
                    }
                } else {
                    Text("No hay datos disponibles.")
                }
            }
            .onAppear {
                Task{
                    do {
                        patientData = try getPatientData()
                        let healthData = try await loadListData()
                        standardList = healthData
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
            .background(Color.clear)
        }
    }
}

#Preview {
    ModifyHealthDataListView()
}
