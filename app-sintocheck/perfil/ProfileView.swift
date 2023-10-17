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
            VStack {
                NavigationView {
                    VStack {
                        HStack(alignment: .center) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70)
                                .padding(.leading, -80)
                                
                            VStack(alignment: .leading) {
                                Text("\(name)")
                                Text("\(phoneNumber)")
                            }
        
                        }
                        Spacer()
                        
        
                    }
                    .padding()
                    .navigationTitle("Mi perfil")
                }
            }
    }
}

#Preview {
    ProfileView()
}
