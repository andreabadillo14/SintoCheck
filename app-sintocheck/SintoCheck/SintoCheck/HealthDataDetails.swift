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
    @Binding var personalizedList : [HealthDataResponse]?
    @Binding var standardList : [HealthDataResponse]?
    
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
                    
                    if trackedHealthDataList?.isEmpty == false {
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
                        NoTrackedHealthDataView(standardList: $standardList, personalizedList: $personalizedList)
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
        HStack {
            if oneHealthData.quantitative {
                // Display an icon for quantitative data
                Image(systemName: "heart.circle.fill")
                    .foregroundColor(Color(red: 168/255, green: 183/255, blue: 171/255))
                    .padding(.trailing, 4)
            } else {
                Image(systemName: "heart.square.fill")
                    .foregroundColor(Color(red: 246/255, green: 226/255, blue: 127/255))
            }

            Text(oneHealthData.name)
        }
    }
}

struct HealthDataDetails_Previews: PreviewProvider {
    @State static var previewHealthData: [HealthDataResponse]? = [
        HealthDataResponse(id: "6525e53c250bcddf903d32d5", name: "Tos", quantitative: false, patientId: "1", rangeMin: 1, rangeMax: 10, unit: "", tracked: false, createdAt: ""),
        HealthDataResponse(id: "6525e53c250bcddf903d32d5", name: "Tos", quantitative: false, patientId: "1", rangeMin: 1, rangeMax: 10, unit: "", tracked: false, createdAt: "")
    ]
    
    static var previews: some View {
        HealthDataDetails(personalizedList: $previewHealthData, standardList: $previewHealthData)
    }
}
