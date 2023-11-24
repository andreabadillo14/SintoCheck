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
    @State var rangeMin : Double = 0.0
    @State var rangeMax : Double = 0.0
    
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
        return String(dateString.prefix(10))
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
                .foregroundStyle(
                    LinearGradient(colors: [
                        Color(red: 168/255, green: 183/255, blue: 171/255),
                        Color(red: 246/255, green: 226/255, blue: 127/255),
                        Color(red: 155/255, green: 190/255, blue: 199/255)
                        
                    ],
                    startPoint: .leading,
                    endPoint: .trailing)
                )
                .frame(height: 270)
                .padding()
                .chartYScale(domain: [rangeMin, rangeMax])
                .chartXAxis {
                    AxisMarks {
                        AxisValueLabel {
                            Text(formattedDate(AHealthData.createdAt))
                        }
                    }
                }
                
                Text("Notas")
                    .bold()
                    .font(.title2)
                
                List {
                    ForEach(healthDataList ?? [], id: \.id) { healthData in
                        NavigationLink(destination: HealthDataNoteDetailView(note: healthData.note, value: healthData.value, dateRegistered: healthData.createdAt, unit: AHealthData.unit ?? "", dataHealthName: AHealthData.name)) {
                            HStack {
                                let previewNote = healthData.note.prefix(17) + "..."
                                Text(previewNote)
                                    .padding()
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                                    .padding(.bottom, 10)
                                
                                VStack {
                                    //Spacer()
                                    Text(formattedDate(healthData.createdAt))
                                        .font(.system(size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.bottom, 4)
                                    
                                    let value = String(format: "%.1f %@", healthData.value, AHealthData.unit ?? "")
                                    Text(value)
                                        .bold()
                                        .font(.title3)
                                    Spacer(minLength: 1)
                                    HStack {
                                        Image(systemName: "clock.fill")
                                                    .foregroundColor(Color(red: 155/255, green: 190/255, blue: 199/255))
                                                    .imageScale(.small)
                                        let time = healthData.createdAt.dropFirst(11).prefix(5)
                                        let timeString = String(time) + " hrs"
                                        Text(String(timeString))
                                            .font(.system(size: 10))
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 10)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                Task{
                    do {
                        patientData = try getPatientData()
                        let healthDataID = AHealthData.id
                        let healthData = try await getValuesOfHealthData(healthDataId: healthDataID)
                        healthDataList = healthData
                        
                        rangeMin = AHealthData.rangeMin ?? 1
                        rangeMax = AHealthData.rangeMax ?? 10
                        
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

//struct expandView : View {
//    @State var healthDataList : [HealthDataRecordResponse]?
//    @State private var selectedHealthData: HealthDataRecordResponse?
//    
//    var body: some View {
//        List {
//                    ForEach(healthDataList ?? [], id: \.id) { healthData in
//                        DisclosureGroup(
//                            isExpanded: Binding(
//                                get: { selectedHealthData?.id == healthData.id },
//                                set: { newValue in
//                                    if newValue {
//                                        selectedHealthData = healthData
//                                    } else {
//                                        selectedHealthData = nil
//                                    }
//                                }
//                            ),
//                            content: {
//                                HealthDataDetailView(AHealthData: healthData)
//                            },
//                            label: {
//                                HStack {
//                                    // Your existing content here
//                                }
//                            }
//                        )
//                    }
//                }
//    }
//}

#Preview {
    HealthDataDetailView(AHealthData: HealthDataResponse(id: "", name: "", quantitative: false, rangeMin: 0.0, rangeMax: 0.0, unit: "", tracked: false, createdAt: ""))
}
