//
//  ContentView.swift
//  perfil-SintoCheck
//
//  Created by Andrea Badillo on 10/16/23.
//

import SwiftUI

struct ContentView: View {
   
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

    
    var body: some View {
        VStack (spacing: 0){
            Image("Logo Chiquito")
                .frame(width: 100, height: 150)
            Text("Iniciar Sesión")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .padding(.top, 35)
            Text("Teléfono")
                .padding(.top, 25)
                .padding(.bottom, 15)
            TextField("Teléfono", text: $phone)
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(phone != "" ? Color(Color(red: 148/255, green: 28/255, blue: 47/255)) : Color.black, lineWidth: 2))
                .keyboardType(.numberPad)
            
            Text("Contraseña")
                .padding(.top, 25)
                .padding(.bottom, 15)
            SecureField("Contraseña", text: $pass)
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(pass != "" ? Color(Color(red: 148/255, green: 28/255, blue: 47/255)) : Color.black, lineWidth: 2))
                .padding(.bottom, 25)
            Button(action: {
                Task {
                    await postLogin()
                }
            }){
                Text("Iniciar Sesión")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(azul)
            .cornerRadius(10)
            .padding(.top, 25)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Telefono o Contraseña Incorrecta"), dismissButton: .default(Text("Entendido")))
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
            .padding(.top, 15)
            
        }
        .padding(.horizontal, 25)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//#Preview {
//    ContentView()
//}
