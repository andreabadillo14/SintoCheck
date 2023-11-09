//
//  DoctorDetailsView.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 10/20/23.
//

import SwiftUI

struct DoctorDetailsView: View {
    var body: some View {
        //Recibir una lista de DoctorDetails y para cada uno generar un InfoDoctor
        let doctors: [DoctorDetails] = [
                DoctorDetails(id: UUID(), name: "Astrid", lastname: "Serna", birthdate: "01/01/1980", height: 175.0, weight: 70.0, medicine: "Cardiología", medicalBackground: "Cardiología"),
                DoctorDetails(id: UUID(), name: "Paula", lastname: "Salinas", birthdate: "02/02/1990", height: 165.0, weight: 60.0, medicine: "Dermatología", medicalBackground: "Dermatología"),
                DoctorDetails(id: UUID(), name: "Juan", lastname: "Perez", birthdate: "03/03/1985", height: 180.0, weight: 80.0, medicine: "Neurología", medicalBackground: "Neurología")
            ]
        
        NavigationView {
            
            VStack(spacing:50) {
                List(doctors) { doctor in
                    InfoDoctor(name: doctor.name, lastname: doctor.lastname, medicine: doctor.medicine, medicalBackground: doctor.medicalBackground, phoneNumber: "8116318324")
                    }
                    
                   

                }.listStyle(.sidebar)
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                .background(Color.clear)
                Spacer()
                
            }
            .navigationTitle("Doctores registrados")
        }
//        .onAppear(perform: {
//            fetchDoctors { doctor in
//                self.doctor = doctor
//            }
//        })
}

struct DoctorDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorDetailsView()
    }
}
