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
    
    var body: some View {
        
        NavigationView {
            
            VStack() {
                Image("Logo Chiquito")
                    .resizable()
                    .frame(width: 50, height: 50)

                Divider()
                    .background(Color(red: 26/255, green: 26/255, blue: 102/255))
                    .frame(width: 390, height: 1)
                Text("Doctores registrados")
                    .bold()
                    .font(.title)
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
                            title: Text("Hola"), message: Text("¿Estas seguro que quieres eliminar al doctor?"),
                            primaryButton: .default(
                                Text("cancelar"),
                                action: {}
                            ),
                            secondaryButton: .destructive(
                                Text("Eliminar"),
                                action: {
                                    deleteDoctor(doctorId: currentDoctorId) { doctor in
                                        self.doctor = doctor
                                        fetchDoctor { doctors in
                                            self.doctors = doctors
                                        }
                                    }
                                    
                                }
                            )
                        )
                    }
                }
                    
            }.listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                .background(Color.clear)
                Spacer()
                
            }
            //.navigationTitle("Doctores registrados")
            .onAppear(perform: {
                fetchDoctor { doctors in
                    self.doctors = doctors
                }
            })
        }
        
}




struct DoctorDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorDetailsView()
    }
}

