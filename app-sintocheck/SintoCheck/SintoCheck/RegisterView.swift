//
//  RegisterView.swift
//  SintoCheck
//
//  Created by Alumno on 23/10/23.
//

import SwiftUI

struct RegisterView: View {
    @State var nombre = ""
    @State var phone = ""
    @State var pass = ""
    @State var ConfirmPass = ""
    @State var mostrarLogin = false
    @State var mostrarDatosAdicionales = false
    let rojo = Color(red: 148/255, green: 28/255, blue: 47/255)
    let azul = Color(red: 26/255, green: 26/255, blue: 102/255)
    var body: some View {
        VStack (spacing: 0){
            Image("Logo")
                .frame(width: 100, height: 150)
            Text("Registro")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
            Text("Introduce tu Informacion")
                .font(.title3)
            Text("Nombre")
                .padding(.top, 25)
                .padding(.bottom, 15)
            TextField("Nombre", text: $nombre)
                .frame(height: 5)
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(phone != "" ? Color(Color(red: 148/255, green: 28/255, blue: 47/255)) : Color.black, lineWidth: 2))
                
            Text("Telefono")
                .padding(.top, 25)
                .padding(.bottom, 15)
            TextField("Telefono", text: $phone)
                .frame(height: 5)
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(phone != "" ? Color(Color(red: 148/255, green: 28/255, blue: 47/255)) : Color.black, lineWidth: 2))
                .keyboardType(.numberPad)
            
            Text("Contraseña")
                .padding(.top, 25)
                .padding(.bottom, 15)
            SecureField("Contraseña", text: $pass)
                .frame(height: 5)
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(pass != "" ? Color(Color(red: 148/255, green: 28/255, blue: 47/255)) : Color.black, lineWidth: 2))
            Text("Confirma tu Contraseña")
                .padding(.top, 25)
                .padding(.bottom, 15)
            SecureField("Contraseña", text: $pass)
                .frame(height: 5)
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(pass != "" ? Color(Color(red: 148/255, green: 28/255, blue: 47/255)) : Color.black, lineWidth: 2))
                .padding(.bottom, 25)
            Button(action: {
                mostrarDatosAdicionales = true
            }){
                Text("Siguiente")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .fullScreenCover(isPresented: $mostrarDatosAdicionales){
                    RegisterOptionalDataView()
                }
            .background(Color(red: 148/255, green: 28/255, blue: 47/255))
            .cornerRadius(10)
            .padding(.top, 25)
            HStack{
                Text("Ya tienes una cuenta?")
                Button(action: {
                    mostrarLogin = true
                }){
                    Text("Iniciar Sesion")
                        .foregroundColor(azul)
                }
                .fullScreenCover(isPresented: $mostrarLogin){
                    LoginView()
                }
            }
            .padding(.top, 15)
            
        }
        .padding(.horizontal, 25)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
