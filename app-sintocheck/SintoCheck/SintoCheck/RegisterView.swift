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
    @State var showAlert = false
    
    @State var AlertText = ""
    
    let rojo = Color(red: 148/255, green: 28/255, blue: 47/255)
    let azul = Color(red: 26/255, green: 26/255, blue: 102/255)
    
    func validarPassword(_ password: String) -> Bool {
            let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$"
            return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
        }
    
    var body: some View {
        VStack (spacing: 0){
            Image("Logo")
                .resizable()
                .frame(width: 150, height: 150)
                
            Text("Registro")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
            Text("Introduce tu Información")
                .font(.title3)
            Text("Nombre")
                .padding(.top, 25)
                .padding(.bottom, 15)
            TextField("Nombre", text: $nombre)
                .frame(height: 5)
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(phone != "" ? Color(Color(red: 148/255, green: 28/255, blue: 47/255)) : Color.black, lineWidth: 2))
                
            Text("Teléfono")
                .padding(.top, 25)
                .padding(.bottom, 15)
            TextField("Teléfono", text: $phone)
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
            SecureField("Contraseña", text: $ConfirmPass)
                .frame(height: 5)
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(ConfirmPass != "" ? Color(Color(red: 148/255, green: 28/255, blue: 47/255)) : Color.black, lineWidth: 2))
            Button(action: {
                if nombre != "" &&
                   phone != "" &&
                    pass != "" &&
                    ConfirmPass != "" && pass == ConfirmPass && validarPassword(pass) == true && phone.count == 10{
                    mostrarDatosAdicionales = true
                    return
                }
                if phone.count != 10{
                    showAlert = true
                    AlertText = "Introduce un telefono valido (10 digitos)"
                    return
                }
                if nombre == "" ||
                        phone == "" ||
                        pass == "" ||
                        ConfirmPass == "" {
                    AlertText = "Por favor introduce todos los datos"
                    showAlert = true
                    return
                         }
                if validarPassword(pass) == false{
                    showAlert = true
                    AlertText = "Tu contraseña debe tener mínimo 8 caracteres, de los cuales al menos uno sea un número y un carácter especial"
                    return
                }
                if pass != ConfirmPass {
                    showAlert = true
                    AlertText = "Las contraseñas no coinciden"
                    return
                }
            }){
                Text("Siguiente")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .alert(AlertText, isPresented : $showAlert, actions: {})
            .fullScreenCover(isPresented: $mostrarDatosAdicionales){
                RegisterOptionalDataView(birthDateS: "", heightS: "", weightS: "", height: 0.0, weight: 0.0, medicine: "", background: "", nombre: nombre, phone: phone, pass: pass, ConfirmPass: pass)
                }
            .background(azul)
            .cornerRadius(10)
            .padding(.top, 25)
            HStack{
                Text("¿Ya tienes una cuenta?")
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
