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
    @State var isTokenValid = false
    @State var goToLogin = true
    
    let rojo = Color(red: 148/255, green: 28/255, blue: 47/255)
    let azul = Color(red: 26/255, green: 26/255, blue: 102/255)
    
    
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
        VStack (spacing: 0) {
          
        }
        .fullScreenCover(isPresented: $isTokenValid) {
            SwitchView()
        }
        .fullScreenCover(isPresented: $goToLogin) {
            LoginView()
        }
        .onAppear {
            Task {
                isTokenValid = try await getHealthDataToProveLogin()
            }
        }
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
