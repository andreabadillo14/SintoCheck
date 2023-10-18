//
//  ProfileView.swift
//  perfil-SintoCheck
//
//  Created by Andrea Badillo on 10/16/23.
//

import SwiftUI

struct ProfileView: View {
    @State var name = "Hermenegildo Pérez"
    @State var phoneNumber = "81-1254-0017"
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack(alignment: .center) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 90)
                            .padding(.leading, -60)
                        
                        VStack(alignment: .leading) {
                            Text("\(name)")
                            Text("\(phoneNumber)")
                        }
                        .padding(.leading)
                        
                    }
                    Spacer()
                    
                    Section {
                        List {
                            NavigationLink(destination: MedicalDataView()) {
                                Text("Detalles personales médicos")
                            }
                            NavigationLink(destination: HealthDataDetails()) {
                                Text("Detalles de datos de salud")
                            }

                        }
                        
                    }
                    Section {
                        List {
                            NavigationLink(destination: MedicalDataView()) {
                                Text("Detalles de médico")
                            }
                            
                        }
                        
                    }
                    
                    Section {
                        List {
                            NavigationLink(destination: MedicalDataView()) {
                                Text("Enlazar a un médico")
                            }
                            
                        }
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                }
                .padding()
                // 124,152,159
                .navigationTitle("Mi perfil")
                //.foregroundColor(Color(red: 124/255, green: 152/255, blue: 159/255))
                
            }
            
            .background(Color.clear)
            //.navigationTitle("Mi perfil")
            
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
