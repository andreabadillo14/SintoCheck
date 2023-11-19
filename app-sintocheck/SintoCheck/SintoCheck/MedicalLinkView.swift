//
//  MedicalLinkView.swift
//  SintoCheck
//
//  Created by Sebastian on 08/11/23.
//

import SwiftUI



func makeLink(doctorCodigo: String, completion: @escaping (Doctor?) -> Void) {
    //obtener id del usuario que inicio sesion esta hardcodeado ahora
    guard let url = URL(string: "https://sintocheck-backend.vercel.app/doctorPatientRelationship") else {return}
    var request = URLRequest(url: url)
    //obtener token del inicio de sesion esta hardcodeado ahora.
    request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1NGVhMDlmZDlmYjc5MWI0YjdmMDg3YyIsIm5hbWUiOiJQYWNpZW50ZSBDZXJvIiwicGhvbmUiOiIwOTg3NjU0MzIxIiwiaWF0IjoxNjk5NjUxODE4LCJleHAiOjE3MDA4NjE0MTh9.Z_WvGy2TCsvFr9_eW_V3ModNnupaUr1_B9QtNG7I97A", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let bodyData = [
        //tomar doctorId como parametro a la funcion
        "doctorCode" : doctorCodigo,
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
    
    @State var Strings : [String] = ["","","","","","", "", ""]
    private enum Field: Int, CaseIterable {
        case field1, field2, field3, field4, field5, field6, field7, field8
    }
    private func textFieldDidChange(_ text: String, for field: Field) {
      if text.isEmpty {
          focusedField = Field(rawValue: field.rawValue - 1)
      } else if text.count > 0 {
          
          focusedField = Field(rawValue: field.rawValue + 1)
      }
    }

    @FocusState private var focusedField: Field?
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack {
                    //cambiar estos ZStacks a otra view
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height:50)
                            .foregroundColor(Color(red: 236/255, green: 239/255, blue: 235/255))
                        HStack {
                            TextField("A", text: $Strings[0])
                                .focused($focusedField, equals: .field1)
                                .onChange(of: $Strings[0].wrappedValue) { oldValue, newValue in
                                    textFieldDidChange(newValue, for: .field1)
                                }
                                .onChange(of: $Strings[0].wrappedValue) { oldValue, newValue in
                                                if Strings[0].count > 1 {
                                                    Strings[0] = String(Strings[0].prefix(1))
                                                }
                                            }
                            
                                .frame(width:20)
                                .font(.system(size: 36))
                                .foregroundColor(Color(red: 48/255, green: 48/255, blue: 48/255))
                            //color blanco Color(red: 236/255, green: 239/255, blue: 235/255)
                            //color negro Color(red: 48/255, green: 48/255, blue: 48/255)
    //                            .background(Color.red)
                        }.padding(.trailing, 3)
                        
                        
                    }
                    
                        
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height:50)
                            .foregroundColor(Color(red: 236/255, green: 239/255, blue: 235/255))
                        HStack {
                            TextField("B", text: $Strings[1])
                                .focused($focusedField, equals: .field2)
                                .onChange(of: $Strings[1].wrappedValue) { oldValue, newValue in
                                    textFieldDidChange(newValue, for: .field2)
                                }
                                .onChange(of: $Strings[1].wrappedValue) { oldValue, newValue in
                                                if Strings[1].count > 1 {
                                                    Strings[1] = String(Strings[1].prefix(1))
                                                }
                                            }
                                .frame(width:20)
                                .font(.system(size: 36))
                                .foregroundColor(Color(red: 48/255, green: 48/255, blue: 48/255))
                        }.padding(.trailing, 3)
                        
                        
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height:50)
                            .foregroundColor(Color(red: 236/255, green: 239/255, blue: 235/255))
                        HStack {
                            TextField("C", text: $Strings[2])
                                .focused($focusedField, equals: .field3)
                                .onChange(of: $Strings[2].wrappedValue) { oldValue, newValue in
                                    textFieldDidChange(newValue, for: .field3)
                                }
                                .onChange(of: $Strings[2].wrappedValue) { oldValue, newValue in
                                                if Strings[2].count > 1 {
                                                    Strings[2] = String(Strings[2].prefix(1))
                                                }
                                            }
                                .frame(width:20)
                                .font(.system(size: 36))
                                .foregroundColor(Color(red: 48/255, green: 48/255, blue: 48/255))
                        }.padding(.trailing, 3)
                        
                        
                    }
                    Text("-")
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height:50)
                            .foregroundColor(Color(red: 236/255, green: 239/255, blue: 235/255))
                        HStack {
                            TextField("D", text: $Strings[3])
                                .focused($focusedField, equals: .field4)
                                .onChange(of: $Strings[3].wrappedValue) { oldValue, newValue in
                                    textFieldDidChange(newValue, for: .field4)
                                }
                                .onChange(of: $Strings[3].wrappedValue) { oldValue, newValue in
                                                if Strings[3].count > 1 {
                                                    Strings[3] = String(Strings[3].prefix(1))
                                                }
                                            }
                                .frame(width:20)
                                .font(.system(size: 36))
                                .foregroundColor(Color(red: 48/255, green: 48/255, blue: 48/255))
                        }.padding(.trailing, 3)
                        
                        
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height:50)
                            .foregroundColor(Color(red: 236/255, green: 239/255, blue: 235/255))
                        HStack {
                            TextField("E", text: $Strings[4])
                                .focused($focusedField, equals: .field5)
                                .onChange(of: $Strings[4].wrappedValue) { oldValue, newValue in
                                    textFieldDidChange(newValue, for: .field5)
                                }
                                .onChange(of: $Strings[4].wrappedValue) { oldValue, newValue in
                                                if Strings[4].count > 1 {
                                                    Strings[4] = String(Strings[4].prefix(1))
                                                }
                                            }
                                .frame(width:20)
                                .font(.system(size: 36))
                                .foregroundColor(Color(red: 48/255, green: 48/255, blue: 48/255))
                        }.padding(.trailing, 3)
                        
                        
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height:50)
                            .foregroundColor(Color(red: 236/255, green: 239/255, blue: 235/255))
                        HStack {
                            TextField("F", text: $Strings[5])
                                .focused($focusedField, equals: .field6)
                                .onChange(of: $Strings[5].wrappedValue) { oldValue, newValue in
                                    textFieldDidChange(newValue, for: .field6)
                                }
                                .onChange(of: $Strings[5].wrappedValue) { oldValue, newValue in
                                                if Strings[5].count > 1 {
                                                    Strings[5] = String(Strings[5].prefix(1))
                                                }
                                            }
                                .frame(width:20)
                                .font(.system(size: 36))
                                .foregroundColor(Color(red: 48/255, green: 48/255, blue: 48/255))
                        }.padding(.trailing, 3)
                    }
                    
                }
                .padding(.horizontal, 20)
                Spacer()
                HStack {
                    Spacer()
                    Button  {
                        //obtener el doctorCodigo y correr makeLink con eso
                        let doctorCodigo = Strings[0] + Strings[1] + Strings[2] + Strings[3] + Strings[4] + Strings[5]
                        
                        makeLink(doctorCodigo: doctorCodigo) { doctor in
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
                                .foregroundColor(Color(red: 26/255, green: 26/255, blue: 102/255))
                            Text("Registrar doctor")
                                .foregroundColor(Color(red: 236/255, green: 239/255, blue: 235/255))
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
        }.onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    MedicalLinkView(exito: .constant(false), mensajeLink: .constant("doctor"))
}
