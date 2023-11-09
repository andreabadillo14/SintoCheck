//
//  InfoDoctor.swift
//  SintoCheck
//
//  Created by Sebastian on 06/11/23.
//

import SwiftUI

struct InfoDoctor: View {
    let name: String
    let lastname: String
    //supongo que posicion de medicina
    let medicine: String
    //especialidad
    let medicalBackground: String
    //agrego numero de telefono porque creo que falta pero tal vez lo quitaron, string porque tal vez tiene +52 o algo raro.
    let phoneNumber: String
    
    var body: some View {
        //ahora todo esta en el centro, hacer que empieze hasta la izquierda y se mueva cierta cantidad a derecha mejor
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 90)
            
            VStack(alignment: .leading) { // esto sigue hardcordeado
                Text(medicine)
                    .foregroundColor(Color.gray)
                    .font(.system(size: 14))
                Text("\(name) \(lastname)")
                HStack {
                    Text(phoneNumber)
                    Image(systemName: "phone.fill")
                        .scaleEffect(x: -1, y: 1)
                }
                HStack {
                    Text("Especialidad: ")
                        .foregroundColor(.gray)
                        .font(.system(size:14))
                    Text(medicalBackground)
                        .font(.system(size:14))
                }
            }
            //.padding(.leading)
            Spacer()
        }
            .padding(.leading,15)
    }
}

#Preview {
    InfoDoctor(name: "Astrid", lastname: "Serna", medicine: "Doctora", medicalBackground: "Cardiología", phoneNumber: "81-1254-0017")
}
