//
//  RegisterOptionalDataView.swift
//  SintoCheck
//
//  Created by Alumno on 12/11/23.
//

import SwiftUI

struct RegisterOptionalDataView: View {
    @State var birthDate = Date()
    @State var phone = ""
    @State var pass = ""
    @State var ConfirmPass = ""
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
            Text("Opcional")
                .font(.caption)
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
            DatePicker("Fecha de Nacimiento", selection: $birthDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.top, 25)
                HStack{
                    VStack{
                        Text("Estatura")
                            .padding(.top, 25)
                            .padding(.bottom, 15)
                        HStack{
                            TextField("Estatura", text: $phone)
                                .frame(height: 5)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(phone != "" ? Color(Color(red: 148/255, green: 28/255, blue: 47/255)) : Color.black, lineWidth: 2))
                                .keyboardType(.numberPad)
                            Text("m")
                        }
                    }
                    VStack{
                        Text("Peso")
                            .padding(.top, 25)
                            .padding(.bottom, 15)
                        HStack{
                            TextField("Peso", text: $pass)
                                .frame(height: 5)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(pass != "" ? Color(Color(red: 148/255, green: 28/255, blue: 47/255)) : Color.black, lineWidth: 2))
                                .keyboardType(.numberPad)
                        Text("kg")
                        }
                    }
                }
            Text("Medicamentos")
                .padding(.top, 25)
                .padding(.bottom, 15)
            TextField("Medicamentos", text: $pass)
                .frame(height: 5)
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(pass != "" ? Color(Color(red: 148/255, green: 28/255, blue: 47/255)) : Color.black, lineWidth: 2))
            Text("Antecedentes")
                .padding(.top, 25)
                .padding(.bottom, 15)
            TextField("Antecedentes", text: $pass)
                .frame(height: 25)
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(pass != "" ? Color(Color(red: 148/255, green: 28/255, blue: 47/255)) : Color.black, lineWidth: 2))
                .padding(.bottom, 25)
            Button(action: {
            }){
                Text("Registrar")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(azul)
            .cornerRadius(10)
            .padding(.top, 25)
        }
        .padding(.horizontal, 25)
    }
    }

struct RegisterOptionalData_Previews: PreviewProvider {
    static var previews: some View {
        RegisterOptionalDataView()
    }
}
