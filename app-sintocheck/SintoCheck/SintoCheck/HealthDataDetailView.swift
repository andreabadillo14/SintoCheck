//
//  HealthDataDetailView.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/9/23.
//

import SwiftUI
import Charts


struct HealthDataDetailView: View {
    var AHealthData : HealthDataResponse
    @State var patientData = AuthenticationResponse()
    @State var healthDataList : [HealthDataRecordResponse]?
    
    enum FileReaderError: Error {
        case fileNotFound
        case fileReadError
    }
    
    func getValuesOfHealthData(healthDataId: String) async throws -> [HealthDataRecordResponse] {
        guard let url = URL(string: "https://sintocheck-backend.vercel.app/healthDataRecords/\(patientData.id)/\(healthDataId)") else {
            fatalError("Invalid URL")
            
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Authorization")
        urlRequest.setValue(patientData.token, forHTTPHeaderField: "Authorization")
        
        let(data, response) = try await URLSession.shared.data(for: urlRequest)
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code: ", httpResponse.statusCode)
            
            if httpResponse.statusCode != 200 {
                print("Response Data: ", String(data: data, encoding: .utf8) ?? "No data")
                throw FileReaderError.fileReadError
            }
        } else {
            throw FileReaderError.fileReadError
        }
        
        let healthDataRecordResponses = try JSONDecoder().decode([HealthDataRecordResponse].self, from: data)
            return healthDataRecordResponses
    }
    
    // Function to format the date string
    func formattedDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            print(dateFormatter.string(from: date))
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    var body: some View {
        ZStack {
            Color("Backgrounds")
                .ignoresSafeArea()
            VStack {
                Text(AHealthData.name)
                    .font(.title)
                    .bold()
                
                
                Chart {
                    ForEach(healthDataList ?? [], id: \.id) { healthData in
                        LineMark(x: .value("Fecha de registro", (healthData.createdAt)),
                                 y: .value("Dato de salud", healthData.value))
                    }
                    
                }
                .frame(height: 270)
                .padding()
                
                Text("Notas")
                    .bold()
            }
            .onAppear {
                Task{
                    do {
                        patientData = try getPatientData()
                        let healthDataID = AHealthData.id
                        let healthData = try await getValuesOfHealthData(healthDataId: healthDataID)
                        healthDataList = healthData
                        let dateforr = AHealthData.createdAt
                        let datefor = formattedDate(dateforr)
                        print("fecha disque formateada \(datefor)")
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
    HealthDataDetailView(AHealthData: HealthDataResponse(id: "", name: "", quantitative: false, rangeMin: 0.0, rangeMax: 0.0, unit: "", tracked: false, createdAt: ""))
}
