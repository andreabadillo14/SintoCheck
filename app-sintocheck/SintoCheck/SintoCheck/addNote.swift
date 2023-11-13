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

//estoy seguro que todos estos requests se pueden manejar como una sola funcion en lugar de estar haciendo copy paste como lo hago, pero no se como tomar el tipo de dato como parametro entonces por ahora lo hago asi.
func addNoteAPI(title: String, content: String, completion: @escaping (Note?) -> Void) {
    //obtener id del usuario que inicio sesion esta hardcodeado ahora
    guard let url = URL(string: "https://sintocheck-backend.vercel.app/note") else {return}
    var request = URLRequest(url: url)
    //obtener token del inicio de sesion esta hardcodeado ahora.
    request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1NGVhMDlmZDlmYjc5MWI0YjdmMDg3YyIsIm5hbWUiOiJQYWNpZW50ZSBDZXJvIiwicGhvbmUiOiIwOTg3NjU0MzIxIiwiaWF0IjoxNjk5NjUxODE4LCJleHAiOjE3MDA4NjE0MTh9.Z_WvGy2TCsvFr9_eW_V3ModNnupaUr1_B9QtNG7I97A", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let bodyData = [
        //tomar doctorId como parametro a la funcion
        "title" : title,
        "content" : content,
        //obtener del login no hardcodeado como ahora.
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
                let doctoresAPI = try decoder.decode(Note.self, from: data)
                print("Data: \(doctoresAPI)")
                completion(doctoresAPI)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }
    }.resume()
}


struct addNote: View {
    @State var titulo = ""
    @State var contenido = ""
    @State var note: Note?
    var body: some View {
        VStack {
            Spacer()
            HStack {
                //cambiar tipografia de titulo
                Text("Titulo: ")
                TextField("titulo", text: $titulo)
                    .textFieldStyle(.roundedBorder)
            }.padding(.horizontal, 20)
            
            Spacer()
            Text("Contenido:")

                //tal vez ponerle algo como overlay para que se vea mejor.
            TextField("Introducir el contenido de tu nota", text: $contenido, axis: .vertical)
    //                .textFieldStyle(MyTextFieldStyle())
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 20)
            Spacer()
            Button {
                addNoteAPI(title: titulo, content: contenido) { note in
                    self.note = note
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.blue)
                    Text("Registrar Nota")
                        .foregroundColor(Color.white)
                        .bold()
                }
            }
            .padding()
            .frame(height:80)
            Spacer()
                
                
            
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
