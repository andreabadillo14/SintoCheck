//
//  AddPersonalizedHealthDataView.swift
//  SintoCheck
//
//  Created by Alumno on 22/11/23.
//

import SwiftUI

struct AddPersonalizedHealthDataView: View {
    @State var patientData = AuthenticationResponse()
    @State var healthData: HealthDataResponse
    
    @State var name : String
    @State var rangoInferior: String
    @State var rangoSuperior : String
    @State var unidades : String
    @State var rangeMin : Double
    @State var rangeMax : Double
    @State var quantitative : Bool
    @State var registerSuccessful : Bool
    
    let azul = Color(red: 26/255, green: 26/255, blue: 102/255)
    
    enum PickerOption {
        case cuantitativo
        case cualitativo
    }
    
    @State var selectedOption: PickerOption
    
    
    
    func postHealthData() async throws -> HealthDataResponse{
        print("Entre aqui")
        guard let url = URL(string: "https://sintocheck-backend.vercel.app/personalizedHealthData") else { fatalError("Invalid URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let parameters = PersonalizedHealthDataRequest(
            name: name,
            quantitative: quantitative,
            patientId: patientData.id,
            rangeMin: rangeMin,
            rangeMax: rangeMax,
            unit: unidades)
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
                if httpResponse.statusCode != 201 {
                    print("Response Data:", String(data: data, encoding: .utf8) ?? "No data")
                    throw FileReaderError.fileReadError
                }
                
                if httpResponse.statusCode == 201 {
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
        VStack{
            Text("Registrar Datos de Salud")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .padding(.horizontal)
            HStack{
                Text("Nombre")
                    .padding(.top, 25)
                    .padding(.bottom, 25)
                TextField("Nombre", text: $name)
                    .frame(height: 5)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(name != "" ? Color(Color(red: 148/255, green: 28/255, blue: 47/255)) : Color.black, lineWidth: 2))
                    
                    .padding(.horizontal)
            }
            .padding(.bottom, 25)
            .padding(.horizontal)
            // Picker
            VStack{
                Text("Tipo de Dato")
                    .padding(.bottom, 10)
                Picker("Opciones", selection: $selectedOption) {
                    Text("Cualitativo").tag(PickerOption.cualitativo)
                    Text("Cuantitativo").tag(PickerOption.cuantitativo)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom, 25)
                switch selectedOption {
                case .cualitativo:
                    Text("Dato Cualitativo")
                        .font(.title2)
                    Text("Un dato de salud cualtitativo es aquel que no es medido por algun instrumento")
                        .font(.caption)
                        .padding(.horizontal, 50)
                        .padding(.bottom, 25)
                case .cuantitativo:
                    Text("Dato Cuantitativo")
                        .font(.title2)
                    Text("Un dato de salud cualtitativo es aquel que es medido por algun instrumento")
                        .font(.caption)
                        .padding(.horizontal, 50)
                        .padding(.bottom, 15)
                    Text("Rangos")
                        .font(.title3)
                    VStack{
                        HStack{
                            Spacer()
                            Text("Rango Inferior")
                            Spacer()
                            TextField("Rango Inferior", text: $rangoInferior)
                                .frame(width: 150, height: 5)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(rangoInferior != "" ? Color(Color(red: 148/255, green: 28/255, blue: 47/255)) : Color.black, lineWidth: 2))
                                .keyboardType(.decimalPad)
                            
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 25)
                        HStack{
                            Spacer()
                            Text("Rango Superior")
                            Spacer()
                            TextField("Rango Superior", text: $rangoSuperior)
                                .frame(width: 150, height: 5)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(rangoSuperior != "" ? Color(Color(red: 148/255, green: 28/255, blue: 47/255)) : Color.black, lineWidth: 2))
                                .keyboardType(.decimalPad)
                            
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 25)
                        
                        HStack{
                            Spacer()
                            Text("Unidades")
                            Spacer()
                            TextField("Unidades", text: $unidades)
                                .frame(width: 150, height: 5)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(unidades != "" ? Color(Color(red: 148/255, green: 28/255, blue: 47/255)) : Color.black, lineWidth: 2))
                                .keyboardType(.decimalPad)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 25)
                    }
                }
            }
        }
        Spacer()
        Button(action: {
            rangeMin = Double(rangoInferior) ?? 0.0
            rangeMax = Double(rangoSuperior) ?? 0.0
            if selectedOption == .cuantitativo{
                quantitative = true
            }
            Task {
                do {
                    try await postHealthData()
                        } catch let error as FileReaderError {
                            print("FileReaderError: \(error)")
                            // Manejar FileReaderError específicamente
                        } catch {
                            print("Error desconocido: \(error)")
                            // Manejar cualquier otro tipo de error
                        }
            }
        }){
            Text("Guardar")
                .foregroundColor(.white)
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width - 50)
        }
        .fullScreenCover(isPresented: $registerSuccessful, content: {
            RegisterHealthDataView(healthData: $healthData)
        })
        .background(azul)
        .cornerRadius(10)
        .padding(.bottom, 25)
        .onAppear {
            Task{
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
         }
    }
}

#Preview {
    AddPersonalizedHealthDataView(healthData: HealthDataResponse(id: "", name: "", quantitative: false, patientId: "", rangeMin: 0.0, rangeMax: 0.0, unit: "", tracked: false, createdAt: ""), name: "", rangoInferior: "", rangoSuperior: "", unidades: "", rangeMin: 0.0, rangeMax: 0.0, quantitative: false, registerSuccessful: false, selectedOption: .cualitativo)
}
