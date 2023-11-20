//
//  ProfileView.swift
//  perfil-SintoCheck
//
//  Created by Andrea Badillo on 10/16/23.
//

import SwiftUI

struct ProfileView: View {

    var patients = [
        PatientSignupRequest(id: UUID(), name: "Hermenegildo Perez", phone: "81-1234-1234", password: "mundo", birthdate: "1945-03-25", height: 1.78, weight: 65.4, medicine: "Vitaminas de calcio", medicalBackground: "Genética de diabetes")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Backgrounds")
                    .ignoresSafeArea()
                VStack {
                    VStack {
                        Text("Mi perfil")
                            .bold()
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            
                        HStack(alignment: .center) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 73)
                                .padding(.leading, -60)
                            
                            VStack(alignment: .leading) { // esto sigue hardcordeado
                                Text(patients[0].name)
                                Text(patients[0].phone)
                            }
                            .padding(.leading)
                            
                            
                        }
                        Spacer()
                        
                        Section {
                            List(patients) { patient in
                                NavigationLink(destination: MedicalDataView(APatient: patient)) {
                                    Image(systemName: "aqi.medium")
                                        .foregroundColor(Color(red: 148/255, green: 28/255, blue: 47/255))
                                    Text("Detalles personales médicos")
                                }
                                NavigationLink(destination: HealthDataDetails()) {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(Color(red: 148/255, green: 28/255, blue: 47/255))
                                    Text("Detalles de datos de salud")
                                }

                            }
                            
                        }
                        Section {
                            List {
                                NavigationLink(destination: DoctorDetailsView()) {
                                    Image(systemName: "book.pages")
                                        .foregroundColor(Color(red: 26/255, green: 26/255, blue: 102/255))
                                    Text("Detalles de médico")
                                }
                                NavigationLink(destination: DoctorDetailsView()) {
                                    Image(systemName: "person.crop.circle.badge.plus")
                                        .foregroundColor(Color(red: 26/255, green: 26/255, blue: 102/255))
                                    Text("Enlazar a un médico")
                                }
                                
                            }
                            
                        }
                        
//                        Section {
//                            List {
//                                
//                                
//                            }
//                        }
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()        
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                    .padding()
                    
                    // 124,152,159
                    //.navigationTitle("Mi perfil")
                    //.foregroundColor(Color(red: 124/255, green: 152/255, blue: 159/255))
                    
                }
                
                .background(Color.clear)
            }
            //.navigationTitle("Mi perfil")
//            .task {
//                await getMedicalData()
//            }
            
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

//#Preview {
//    ProfileView()
//}
