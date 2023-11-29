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
        //return String(dateString.prefix(10))
        let startIndex = dateString.index(dateString.startIndex, offsetBy: 5)
        let endIndex = dateString.index(dateString.startIndex, offsetBy: 9)
        let mmddSubstring = dateString[startIndex...endIndex]
        print(mmddSubstring)
        return String(mmddSubstring)
    }
    
    func dateLabelForIndex(_ index: AxisValue, in healthDataList: [HealthDataRecordResponse]) -> String {
        guard let indexValue = index.index as? Int, indexValue >= 0 && indexValue < healthDataList.count else {
            return ""
        }
        return formattedDate(healthDataList[indexValue].createdAt)
    }
    
    var body: some View {
        ZStack {
            Color("Backgrounds")
                .ignoresSafeArea()
            GeometryReader { geometry in
                VStack {
                    Image("Logo Chiquito")
                        .resizable()
                        .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.08)

                    Divider()
                        .background(Color(red: 26/255, green: 26/255, blue: 102/255))
                        .frame(width: geometry.size.width * 1, height: 1)
                    Text(AHealthData.name)
                        .font(.title)
                        .bold()
                        .padding(.horizontal, geometry.size.width * 0.05)
                    
                    if healthDataList?.count ?? 0 == 1 {
                        Image(systemName: "arrow.clockwise.heart.fill")
                            .resizable()
                            .frame(width: geometry.size.width * 0.12, height: geometry.size.height * 0.065)
                            .foregroundColor(Color(red: 148/255, green: 28/255, blue: 47/255)).opacity(0.8)
                            .padding()
                        Text("Solo cuentas con un registro en este dato, por el momento no es posible mostrar la gráfica")
                            .padding()
                            .background(Color(red: 226/255, green: 195/255, blue: 145/255))
                            .cornerRadius(10)
                            .padding()
                    }
                    else if (healthDataList?.isEmpty == true) {
                        Image(systemName: "arrow.clockwise.heart.fill")
                            .resizable()
                            .frame(width: geometry.size.width * 0.12, height: geometry.size.height * 0.065)
                            .foregroundColor(Color(red: 148/255, green: 28/255, blue: 47/255)).opacity(0.8)
                            .padding()
                        Text("No cuentas con ningún registro en este dato, por el momento no es posible mostrar la gráfica")
                            .padding()
                            .background(Color(red: 226/255, green: 195/255, blue: 145/255))
                            .cornerRadius(10)
                            .padding()
                    }
                    else {
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
                        .frame(height: geometry.size.height * 0.25)
                        .padding()
                        .chartYScale(domain: [rangeMin, rangeMax])
                        .chartXAxis {
                            AxisMarks(position: .bottom) { index in
                                AxisValueLabel {
                                    Text(dateLabelForIndex(index, in: healthDataList ?? []))
                                }
                            }
                        }
                    }
                    
                    if healthDataList?.contains(where: { !$0.note.isEmpty }) == true {
                        Text("Notas")
                            .bold()
                            .font(.title2)
                    }
                    
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
                            
                            if (AHealthData.quantitative) {
                                rangeMin = AHealthData.rangeMin ?? 1
                                rangeMax = AHealthData.rangeMax ?? 10
                            } else if (AHealthData.quantitative == false) {
                                rangeMin = 1
                                rangeMax = 10
                            }
                            
    //                        let dateforr = AHealthData.createdAt
    //                        let datefor = formattedDate(dateforr)
    //                        print("fecha disque formateada \(datefor)")
                            //print("aa \(healthDataList?[0].value ?? 0.0)")
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
