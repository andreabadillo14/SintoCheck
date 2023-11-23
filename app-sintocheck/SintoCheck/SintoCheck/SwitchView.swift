//
//  SwitchView.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/20/23.
//

import SwiftUI

struct SwitchView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                        ProfileView()
                            .tabItem {
                                Image(systemName: "person")
                                Text("Perfil")
                            }
                            .tag(0)
                        
                        NoTrackedHealthDataView()
                        .tabItem {
                            Image(systemName: "plus")
                            Text("Añadir registro")
                        }
                            .tag(1)
                        
                        SettingsView()
                            .tabItem {
                                Image(systemName: "gear")
                                Text("Configuración")
                            }
                            .tag(2)
                    }
                    .onAppear {
                        selectedTab = 0 // Set the default selected tab to be the profile view
                }
                    .accentColor(Color(red: 26/255, green: 26/255, blue: 102/255))

            Divider()
                .background(Color(red: 148/255, green: 28/255, blue: 47/255))
                .position(x: 200, y: 710)
        }
    }
}

#Preview {
    SwitchView()
}
