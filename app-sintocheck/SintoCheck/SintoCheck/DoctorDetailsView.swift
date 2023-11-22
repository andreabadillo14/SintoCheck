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
                            //al hacer click quiero que se haga una alerta que pregunte si estas seguro y si le picas eliminar otra vez en la alerta se elimina al doctor completamente.
                            showSure = true
                            currentDoctorId = doctor.id
                            
                        } label: {
                            Image(systemName: "trash.fill")
                        }.tint(.red)
                            
                            
                    }
                    .alert(isPresented: $showSure) {
                        Alert(
                            title: Text("hola"), message: Text("Estas seguro que quieres eliminar al doctor?"),
                            primaryButton: .default(
                                Text("cancelar"),
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

