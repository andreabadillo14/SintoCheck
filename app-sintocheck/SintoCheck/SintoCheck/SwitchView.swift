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
        TabView(selection: $selectedTab) {
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person")
                            Text("Perfil")
                        }
                        .tag(0)
                    
                    AddHealthDataView()
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
    }
}

#Preview {
    SwitchView()
}
