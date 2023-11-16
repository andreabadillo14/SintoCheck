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
     let rojo = Color(red: 148/255, green: 28/255, blue: 47/255)
    let azul = Color(red: 26/255, green: 26/255, blue: 102/255)
    
    var body: some View {
        VStack (spacing: 0){
            Image("Logo")
                .frame(width: 100, height: 150)
            Text("Iniciar Sesion")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .padding(.top, 35)
            Text("Telefono")
                .padding(.top, 25)
                .padding(.bottom, 15)
            TextField("Telefono", text: $phone)
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
                
            }){
                Text("Iniciar Sesion")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(azul)
            .cornerRadius(10)
            .padding(.top, 25)
            HStack{
                Text("No tienes una cuenta?")
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
