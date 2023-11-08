//
//  RegisterView.swift
//  SintoCheck
//
//  Created by Alumno on 23/10/23.
//

import SwiftUI

struct RegisterView: View {
    var body: some View {
        @State var nombre = ""
        @State var celular = ""
        @State var contraseña = ""
        @State var confContraseña = ""
        NavigationView{
            Form{
                VStack{
                    Text("Nombre")
                    TextField("nombre", text: $nombre)
                        .textFieldStyle(.roundedBorder)
                    Text("Numero de celular")
                    TextField("celular", text: $celular)
                        .textFieldStyle(.roundedBorder)
                    Text("Contraseña")
                    TextField("contraseña", text: $contraseña)
                        .textFieldStyle(.roundedBorder)
                    Text("Confirmacion Contraseña")
                    TextField("Confirmacion de contraseña", text: $confContraseña)
                        .textFieldStyle(.roundedBorder)
                    Button("Registrarme"){
                    }
                    .padding()
                    .background(Color.red)
                    .cornerRadius(20)
                    .foregroundColor(.white)
                }
            }
            .navigationTitle("Registro")
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
