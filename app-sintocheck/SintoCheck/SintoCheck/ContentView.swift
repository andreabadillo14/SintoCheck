//
//  ContentView.swift
//  perfil-SintoCheck
//
//  Created by Andrea Badillo on 10/16/23.
//

import SwiftUI

struct ContentView: View {
   
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
                .accentColor(Color(red: 26/255, green: 26/255, blue: 102/255))
            
            Rectangle()
                .fill(Color(red: 148/255, green: 28/255, blue: 47/255))
                .frame(height: 2) // Set the height of the thicker line
                .padding(.top, 650)
                .overlay(
                    Divider()
                        .background(Color(red: 148/255, green: 28/255, blue: 47/255)) // Set the background color of the default divider to clear
                        .padding(.top, 650)
                        
                )
            
        }

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//#Preview {
//    ContentView()
//}
