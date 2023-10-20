//
//  MedicalDataView.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 10/18/23.
//

import SwiftUI

struct MedicalDataView: View {
    var APatient : Patient

    
    var body: some View {
        Section {
            List {
                HStack {
                    Text("Fecha de nacimiento: ")
                    Text(APatient.birthdate)
                }
                
                HStack {
                    Text("Altura: ")
                    Text("\(APatient.height)")
                }
                
                HStack {
                    Text("Peso: ")
                    Text("\(APatient.weight)")
                }
                
                HStack {
                    Text("Medicina: ")
                    Text("\(APatient.medicine)")
                }
                
                HStack {
                    Text("Antecedentes: ")
                    Text("\(APatient.medicalBackground)")
                }
            }
        }
    }
}

#Preview {
    MedicalDataView(APatient: Patient(id: UUID(), birthdate: "1934-04-23", height: 1.65, weight: 0, medicine: "no", medicalBackground: "no"))
}
