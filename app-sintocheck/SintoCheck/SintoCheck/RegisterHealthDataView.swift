//
//  RegisterHealthDataView.swift
//  SintoCheck
//
//  Created by Alumno on 20/11/23.
//

import SwiftUI

struct RegisterHealthDataView: View {
    var healthData: HealthDataResponse
    @State var patientData = AuthenticationResponse()
    @Environment(\.dismiss) var dismissView
    
    @State var value = 5.0
    @State var note = ""
    @State var registerSuccessful = false
    @State var showErrorAlert = false
    
    func postRegisterData() async {
        print("ola")
        guard let url = URL(string: "https://sintocheck-backend.vercel.app/healthDataRecord") else {
            fatalError("Invalid URL")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let parameters = HealthDataRecordRequest(
            patientId: patientData.id,
            healthDataId: healthData.id,
            value: value,
            note: note)
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(parameters)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue(patientData.token, forHTTPHeaderField: "Authorization")
        } catch {
            print("Error: \(error)")
        }
        
        do {
            let (_, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse else { fatalError("Error while fetching data")
            }
            
            print(httpResponse.statusCode)
            if httpResponse.statusCode == 200 {
                print("success")
                self.registerSuccessful = true
            } else {
                // If the login fails, show an alert
                self.showErrorAlert = true
            }
        } catch {
            print("Error: \(error)")
            // If there's an error, show an alert
            self.showErrorAlert = true
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Backgrounds")
                    .ignoresSafeArea()
                VStack {
                    VStack {
                        Section {
                            VStack {
                                Text("Valor")
                                    .font(.system(size: 20))
                                
                                if healthData.quantitative {
                                    HStack {
                                        TextField("Valor", value: $value, format: .number)
                                            .textFieldStyle(.roundedBorder)
                                       // Text(healthData.unit)
                                    }
                                    .frame(width: 150)
                                }
                                else {
                                    VStack {
                                        Slider(value: $value, in: 0...10, step: 1)
                                        HStack {
                                            Text("0")
                                            Spacer()
                                            Text("10")
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                             
                                }
                            }
                            .padding()
                        }
                        
                        Section {
                            Text("Nota")
                                .font(.system(size: 20))
                            TextEditor(text: $note)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding()
                        }
                        
                        Section {
                            HStack(spacing: 40) {
                                Button("Cancelar") {
                                    dismissView()
                                }
                                Button("Confirmar") {
                                    //validate
                                    Task {
                                        await postRegisterData()
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    .padding()
                    .navigationTitle(healthData.name)
                }
                .onAppear {
                    // merge with login and test
                    do {
                        patientData = try getPatientData()
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
                .background(Color.clear)
            }
        }
    }
}

struct RegisterHealthDataView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterHealthDataView(healthData: HealthDataResponse(id: "6525e53c250bcddf903d32d5", name: "Tos", quantitative: false, patientId: "1", rangeMin: 1, rangeMax: 10, unit: "", tracked: false, createdAt: ""))
    }
}

//#Preview {
//    RegisterHealthDataView(healthData: HealthDataResponse(id: "6525e53c250bcddf903d32d5", name: "Tos", quantitative: false, patientId: "1", rangeMin: 1, rangeMax: 10, unit: ""))
//    RegisterHealthDataView(healthData: HealthDataResponse(id: 1, name: "Temperatura", quantitative: true, patientId: 1, rangeMin: 1, rangeMax: 10, unit: "C"))
//}
