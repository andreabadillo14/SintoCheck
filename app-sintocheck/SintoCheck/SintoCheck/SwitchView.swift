//
//  SwitchView.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/20/23.
//

import SwiftUI


extension Binding {
    func onUpdate(_ closure: @escaping () -> Void) -> Binding<Value> {
        Binding(get: {
            wrappedValue
        }, set: { newValue in
            wrappedValue = newValue
            closure()
        })
    }
}

struct SwitchView: View {
    @State private var selectedTab = 0
    //en vez de state sacarlo de un viewModel
    @State var isDismissed: Bool = false
    
    var body: some View {
        TabView(selection: $selectedTab.onUpdate{
            isDismissed.toggle()
            print(isDismissed)
        }) {
                    ProfileView(isDismissed: $isDismissed)
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
