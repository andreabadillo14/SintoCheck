//
//  agregarNota.swift
//  SintoCheck
//
//  Created by Sebastian on 08/11/23.
//

import SwiftUI


//si quiero obtener cuando se creo la nota aqui se puede agregar.
struct Note: Codable, Identifiable {
    let id: String
    let title: String
    let content: String
}


struct addNote: View {
    @State var titulo = ""
    @State var contenido = ""
    @State private var alertValidation = false
    @State private var alertValidationMessage = ""
    @State var note: Note?
    @State var patientData : AuthenticationResponse?
    
    
    
    func handlePatientData() {
        do {
            let sandboxURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = sandboxURL.appendingPathComponent("loginResponse.json")

            if !FileManager.default.fileExists(atPath: fileURL.path) {
                // File does not exist, handle this case accordingly
                print("Login response file not found")
                return
            }
            
            patientData = try getPatientData()
        } catch let error {
            print("An error occurred while retrieving patient data: \(error)")
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            HStack {
                //cambiar tipografia de titulo
                Text("Titulo: ")
                    .foregroundColor(Color(red: 48/255, green: 48/255, blue: 48/255))
                TextField("titulo", text: $titulo)
                    .textFieldStyle(.roundedBorder)
            }.padding(.horizontal, 20)
            
            Spacer()
            Text("Contenido:")
                .foregroundColor(Color(red: 48/255, green: 48/255, blue: 48/255))

//            TextField("Introducir el contenido de tu nota", text: $contenido, axis: .vertical)
//    //                .textFieldStyle(MyTextFieldStyle())
//                .textFieldStyle(.roundedBorder)
//                .padding(.horizontal, 20)
                TextEditor(text: $contenido)
                    .frame(height:150)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
//                    .foregroundColor(.red)
                    .padding()
                
            
            Spacer()
            Button {
                if (titulo != "" && contenido != "") {
                    if let patientData = patientData{
                        addNoteAPI(title: titulo, content: contenido, patientId: patientData.id, patientToken: patientData.token) { note in
                            self.note = note
                        }
                    }
                    
                } else {
                    if (titulo == "" && contenido == "") {
                        alertValidation = true
                        alertValidationMessage = "No puedes registar una nota vacia"
                    } else if (titulo == "") {
                        alertValidation = true
                        alertValidationMessage = "No puedes registrar una nota sin titulo"
                        
                    } else if (contenido == "") {
                        alertValidation = true
                        alertValidationMessage = "No puedes registrar una nota sin contenido"
                    }
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(red: 26/255, green: 26/255, blue: 102/255))
                    Text("Registrar Nota")
                        .foregroundColor(Color(red: 236/255, green: 239/255, blue: 235/255))
                        .bold()
                }
            }
            .padding()
            .frame(height:80)
            .alert(alertValidationMessage, isPresented: $alertValidation) {
                
            }
            Spacer()
                
                
            
        }
        .onAppear(perform: {
            handlePatientData()
        })
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        
    }
}

struct MyTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .padding(.bottom, 150)
        .background(
            RoundedRectangle(cornerRadius: 0, style: .continuous)
                .stroke(Color.black, lineWidth: 1)
        ).padding()
    }
}

#Preview {
    addNote()
}
