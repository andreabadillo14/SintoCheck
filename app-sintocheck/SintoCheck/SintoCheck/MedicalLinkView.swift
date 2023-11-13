//
//  MedicalLinkView.swift
//  SintoCheck
//
//  Created by Sebastian on 08/11/23.
//

import SwiftUI



func makeLink(doctorId: String, completion: @escaping (Doctor?) -> Void) {
    //obtener id del usuario que inicio sesion esta hardcodeado ahora
    guard let url = URL(string: "https://sintocheck-backend.vercel.app/doctorPatientRelationship") else {return}
    var request = URLRequest(url: url)
    //obtener token del inicio de sesion esta hardcodeado ahora.
    request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1NGVhMDlmZDlmYjc5MWI0YjdmMDg3YyIsIm5hbWUiOiJQYWNpZW50ZSBDZXJvIiwicGhvbmUiOiIwOTg3NjU0MzIxIiwiaWF0IjoxNjk5NjUxODE4LCJleHAiOjE3MDA4NjE0MTh9.Z_WvGy2TCsvFr9_eW_V3ModNnupaUr1_B9QtNG7I97A", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let bodyData = [
        //tomar doctorId como parametro a la funcion
        "doctorId" : doctorId,
        "patientId" : "654ea09fd9fb791b4b7f087c"
    ]
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: bodyData, options: [])
    } catch {
        print("Error encoding data: \(error)")
    }


    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
        }
        if let response = response {
            print("Response: \(response)")
        }
        if let data = data {
            do {
                let decoder = JSONDecoder()
                let doctoresAPI = try decoder.decode(Doctor.self, from: data)
                print("Data: \(doctoresAPI)")
                completion(doctoresAPI)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }
    }.resume()
}

struct MedicalLinkView: View {
    @Environment(\.dismiss) var dismiss
    @State var inp = ""
    @Binding var exito : Bool
    @Binding var mensajeLink : String
    @State var doctor: Doctor?
    @State var doctorNombre = ""
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack {
                    Text("Introduce su código")
                    TextField("Codigo del doctor", text: $inp)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal, 20)
                Spacer()
                HStack {
                    Spacer()
                    Button  {
                        makeLink(doctorId: inp) { doctor in
                            self.doctor = doctor
                            
                        }
                        //hacer la logica para registrar al doctor
                        
                        exito = true
                        //poner el nombre del doctor recibido del api, esto es para exito, para catch darle otro mensaje
                        mensajeLink = "Se registro exitasomanete el doctor \(doctor?.name ?? "")"
                        dismiss()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.blue)
                            Text("Registrar doctor")
                                .foregroundColor(Color.white)
                                .bold()
                        }
                    }
                    .padding()
                    .frame(height:80)
                    Spacer()
                }
                Spacer()
            }
            .navigationTitle("Enlace con su medico")
        }
    }
}

#Preview {
    MedicalLinkView(exito: .constant(false), mensajeLink: .constant("doctor"))
}
