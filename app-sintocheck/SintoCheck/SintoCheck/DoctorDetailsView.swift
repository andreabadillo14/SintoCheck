//
//  DoctorDetailsView.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 10/20/23.
//

//TODO: agregar id del usuario que hizo login, token del usuario que hizo login
//mover logica del API a otro archivo para que sea más legible este.
import SwiftUI

struct Doctor: Codable, Identifiable {
    let id: String
    let name: String
    let phone: String
    let speciality: String?
}


struct DoctorDetailsView: View {
    @State var doctors: [Doctor]?
    @State var doctorVacia: [Doctor] = []
    @State var doctor: Doctor?
    @State private var showSure: Bool = false
    @State private var currentDoctorId: String = ""
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State var patientData : AuthenticationResponse?

    func handlePatientData() {
        do {
            let sandboxURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = sandboxURL.appendingPathComponent("loginResponse.json")

            if !FileManager.default.fileExists(atPath: fileURL.path) {
                // File does not exist, handle this case accordingly
                print("Login response file not found")
                return
            }

            patientData = try getPatientData()
        } catch let error {
            print("An error occurred while retrieving patient data: \(error)")
        }
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing:50) {
                List (doctors ?? doctorVacia) { doctor in
                    InfoDoctor(name: doctor.name,  medicalBackground: doctor.speciality ?? "", phoneNumber: doctor.phone).swipeActions {
                        Button {
                            showSure = true
                            currentDoctorId = doctor.id
                            
                        } label: {
                            Image(systemName: "trash.fill")
                        }.tint(.red)
                            
                            
                    }
                    .listRowBackground(colorScheme == .light ? Color(red: 236/255, green: 239/255, blue: 235/255) : Color(UIColor.secondarySystemGroupedBackground))
                    .alert(isPresented: $showSure) {
                        Alert(
                            title: Text("¿Quieres eliminar al doctor?"),
                            primaryButton: .default(
                                Text("Cancelar"),
                                action: {}
                            ),
                            secondaryButton: .destructive(
                                Text("Eliminar"),
                                action: {
                                    if let patientData = patientData {
                                        deleteDoctor(doctorId: currentDoctorId, patientId: patientData.id, patientToken: patientData.token) { doctor in
                                            self.doctor = doctor
                                            fetchDoctor(patientId: patientData.id, patientToken: patientData.token) { doctors in
                                                self.doctors = doctors
                                            }
                                        }
                                    }
                                    
                                    
                                }
                            )
                        )
                    }
                }
                    
                   

                }.listStyle(.sidebar)
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                .background(Color.clear)
                Spacer()
                
            }
            .navigationTitle("Doctores registrados")
            .onAppear(perform: {
                handlePatientData()
                if let patientData = patientData {
                    fetchDoctor(patientId: patientData.id, patientToken: patientData.token) { doctors in
                        self.doctors = doctors
                    }
                }
               
            })
        }
        
}




struct DoctorDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorDetailsView()
    }
}

