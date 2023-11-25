//
//  AddHealthDataRecordView.swift
//  SintoCheck
//
//  Created by Alumno on 22/11/23.
//

import SwiftUI

struct AddHealthDataRecordView: View {
    @State var listEmpty : Bool = true
    let amarillo = Color(red: 246/255, green: 226/255, blue: 127/255)
    @State var getSuccessful = false
    @State var patientData = AuthenticationResponse()
    @Binding var personalizedList : [HealthDataResponse]?
    @Binding var standardList : [HealthDataResponse]?
    
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

    var body: some View {
        VStack{
                if listEmpty{
                    NoTrackedHealthDataView(standardList: $standardList, personalizedList: $personalizedList)
                } else {
                    AddDataRecordListView(standardList: $standardList, personalizedList: $personalizedList, healthData: HealthDataResponse(id: "", name: "", quantitative: false, patientId: "", rangeMin: 0.0, rangeMax: 0.0, unit: "", tracked: false, createdAt: ""))
                }
            }
        
        .onAppear {
            Task{
                do {
                    patientData = try getPatientData()
                    let healthData = try await loadListData()
                    personalizedList = healthData
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

struct AddHealthDataRecordListView_Previews: PreviewProvider {
    static var previews: some View {
    @State var previewHealthData: [HealthDataResponse]? = [
        HealthDataResponse(id: "6525e53c250bcddf903d32d5", name: "Tos", quantitative: false, patientId: "1", rangeMin: 1, rangeMax: 10, unit: "", tracked: false, createdAt: ""),
        HealthDataResponse(id: "6525e53c250bcddf903d32d5", name: "Tos", quantitative: false, patientId: "1", rangeMin: 1, rangeMax: 10, unit: "", tracked: false, createdAt: "")
    ]
        AddHealthDataRecordView(personalizedList: $previewHealthData, standardList: $previewHealthData)
    }
}
