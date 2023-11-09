//
//  MedicalLinkView.swift
//  SintoCheck
//
//  Created by Sebastian on 08/11/23.
//

import SwiftUI

struct MedicalLinkView: View {
    @Environment(\.dismiss) var dismiss
    @State var inp = ""
    @Binding var exito : Bool
    @Binding var mensajeLink : String
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
                    Button {
                        //hacer la logica para registrar al doctor
                        exito = true
                        //poner el nombre del doctor recibido del api, esto es para exito, para catch darle otro mensaje
                        mensajeLink = "Se registro exitasomanete el doctor \(doctorNombre)"
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
