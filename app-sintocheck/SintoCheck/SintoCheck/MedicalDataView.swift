//
//  MedicalDataView.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 10/18/23.
//

import SwiftUI

struct MedicalDataView: View {
    var APatient : PatientSignupRequest
    
    
    var body: some View {
        ZStack {
            Color("Backgrounds")
                .ignoresSafeArea()
            VStack {
                Section {
                    Text("Detalles Personales Médicos")
                        .bold()
                        .font(.largeTitle)
                        .padding(.top, 20)
                    List {
                        HStack {
                            Text("Fecha de nacimiento")
                            Spacer()
                            Text(APatient.birthdate)
                                .opacity(0.8)
                        }
                        
                        HStack {
                            Text("Altura")
                            Spacer()
                            Text(String(format: "%.2f", APatient.height))
                                .opacity(0.8)
                            Text("cm")
                                .opacity(0.8)
                        }
                        
                        HStack {
                            Text("Peso")
                            Spacer()
                            Text(String(format: "%.1f", APatient.weight))
                                .opacity(0.8)
                            Text("kg") 
                                .opacity(0.8)
                        }
                        
                        HStack {
                            Text("Medicina")
                            Spacer()
                            Text("\(APatient.medicine)")
                                .opacity(0.8)
                        }
                        
                        HStack {
                            Text("Antecedentes")
                            Spacer()
                            Text("\(APatient.medicalBackground)")
                                .opacity(0.8)
                        }
                    }
                }
            }
        }
    }
}

struct MedicalDataView_Previews: PreviewProvider {
    static var previews: some View {
        MedicalDataView(APatient: PatientSignupRequest(id: UUID(), name: "Hermenegildo",phone: "81-1234-1234", password: "mundo", birthdate: "1934-04-23", height: 1.65, weight: 0, medicine: "no", medicalBackground: "no"))
    }
}
