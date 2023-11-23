//
//  HealthDataDetails.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 10/17/23.
//

import SwiftUI

struct HealthDataDetails: View {
    
    @State var patientData = AuthenticationResponse()
    @State var trackedHealthDataList : [HealthDataResponse]?
    @State var getSuccessful = false
    
    enum FileReaderError: Error {
        case fileNotFound
        case fileReadError
    }
    
    func getHealthDataTrackedList() async throws -> [HealthDataResponse] {
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
        print(healthDataResponse)
        return healthDataResponse
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Backgrounds")
                    .ignoresSafeArea()
                VStack {
                    
                    if getSuccessful {
                        // Show your list and other content when successful
                        Section {
                            Text("Datos de salud")
                                .bold()
                                .font(.largeTitle)
                                .padding(.top, 20)
                        }

                        List(trackedHealthDataList!, id: \.id) { data in
                            NavigationLink {
                                HealthDataDetailView(AHealthData: data)
                            } label: {
                                Cell(oneHealthData: data)
                            }
                        }
                    } else {
                        // Show another view when not successful
                        NoTrackedHealthDataView()
                    }
                    
                }
                .onAppear {
                    Task{
                        do {
                            patientData = try getPatientData()
                            let healthData = try await getHealthDataTrackedList()
                            trackedHealthDataList = healthData
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
}

struct Cell: View {
    var oneHealthData : HealthDataResponse
    
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
