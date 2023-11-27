//
//  LoginView.swift
//  SintoCheck
//
//  Created by Alumno on 23/10/23.
//

import SwiftUI

struct LoginView: View {
    @State var phone = ""
    @State var pass = ""
    @State var mostrarRegistro = false
    
    @State private var showAlert = false
    @State private var loginSuccessful = false
    
    let rojo = Color(red: 148/255, green: 28/255, blue: 47/255)
    let azul = Color(red: 26/255, green: 26/255, blue: 102/255)
    
    func postLogin() async {
           guard let url = URL(string: "https://sintocheck-backend.vercel.app/login/patient") else { fatalError("Invalid URL") }

           var urlRequest = URLRequest(url: url)
           urlRequest.httpMethod = "POST"

           let parameters = ["phone": phone, "password": pass]
           do {
               urlRequest.httpBody = try JSONEncoder().encode(parameters)
               urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
           } catch {
               print("Error: \(error)")
           }

           do {
               let (data, response) = try await URLSession.shared.data(for: urlRequest)
               guard let httpResponse = response as? HTTPURLResponse else { fatalError("Error while fetching data") }

               if httpResponse.statusCode == 200 {
                   let patientData = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
                   // Handle the decoded data as needed
                   print(patientData.token)
                   self.loginSuccessful = true
                   
                   // Store information in sandbox
                   let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("loginResponse", conformingTo: .json)
                   try? data.write(to: fileURL)
                   
               } else {
                   // If the login fails, show an alert
                   self.showAlert = true
               }
           } catch {
               print("Error: \(error)")
               // If there's an error, show an alert
               self.showAlert = true
           }
       }
    
    func retrieveAuthenticationResponse() async throws -> AuthenticationResponse? {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("loginResponse", conformingTo: .json)

        if let data = try? Data(contentsOf: fileURL) {
            do {
                let authenticationResponse = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
                return authenticationResponse
            } catch {
                print("Error decoding authentication response: \(error)")
                return nil
            }
        } else {
            return nil
        }
    }
    
    func getHealthDataToProveLogin() async throws -> Bool {
        let authenticationResponse = try await retrieveAuthenticationResponse()
        
        guard let url = URL(string: "https://sintocheck-backend.vercel.app/healthData") else {
            fatalError("Invalid URL")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(authenticationResponse?.token, forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) =
     
    try await URLSession.shared.data(for: urlRequest)
            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode == 200 {
                return true
            } else if httpResponse?.statusCode == 401 {
                // Token is invalid, prompt user to log in
                self.showAlert = true
                return false
            } else {
                // Handle other error codes
                print("Unexpected error: \(httpResponse?.statusCode ?? 0)")
                return false
            }
        } catch {
            // Handle network errors
            print("Network error: \(error)")
            return false
        }
    }

    
    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 0) {
                Image("Logo Chiquito")
                    .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.3)
                Text("Iniciar Sesión")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .padding(.top, geometry.size.height * 0.025)
                Text("Teléfono")
                    .padding(.top, geometry.size.height * 0.025)
                    .padding(.bottom, geometry.size.height * 0.015)
                TextField("Teléfono", text: $phone)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(phone != "" ? Color(Color(red: 148/255, green: 28/255, blue: 47/255)) : Color.black, lineWidth: 2))
                    .keyboardType(.numberPad)
                
                Text("Contraseña")
                    .padding(.top, geometry.size.height * 0.025)
                    .padding(.bottom, geometry.size.height * 0.015)
                SecureField("Contraseña", text: $pass)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(pass != "" ? Color(Color(red: 148/255, green: 28/255, blue: 47/255)) : Color.black, lineWidth: 2))
                    .padding(.bottom, geometry.size.height * 0.025)
                Button(action: {
                    Task {
                        await postLogin()
                    }
                }){
                    Text("Iniciar Sesión")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: geometry.size.width - geometry.size.width * 0.2)
                }
                .background(azul)
                .cornerRadius(geometry.size.width * 0.03) // Adjust corner radius based on screen size
                .padding(.top, geometry.size.height * 0.025)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text("Teléfono o Contraseña Incorrecta"), dismissButton: .default(Text("Entendido")))
                }
                .fullScreenCover(isPresented: $loginSuccessful) {
                    SwitchView()
                }

                HStack{
                    Text("¿No tienes una cuenta?")
                    Button(action: {
                        mostrarRegistro = true
                    }){
                        Text("Registrarme")
                            .foregroundColor(azul)
                    }
                    .fullScreenCover(isPresented: $mostrarRegistro){
                        RegisterView()
                    }
                }
                .padding(.top, geometry.size.height * 0.015)
                
            }
            .padding(.horizontal, geometry.size.width * 0.07)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    
    static var previews: some View {
        LoginView()
    }
}
