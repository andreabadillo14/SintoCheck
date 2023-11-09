//
//  agregarNota.swift
//  SintoCheck
//
//  Created by Sebastian on 08/11/23.
//

import SwiftUI

struct addNote: View {
    @State var titulo = ""
    @State var contenido = ""
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
