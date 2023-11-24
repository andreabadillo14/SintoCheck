//
//  HealthDataDetails.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 10/17/23.
//

import SwiftUI

struct HealthDataDetails: View {
    
     var healthData = [
        PersonalizedHealthDataRequest(name: "Tos", quantitative: false, patientId: "", rangeMin: 1, rangeMax: 10, unit: "n/a")
    ]
    
    
    var body: some View {
        ZStack {
            Color("Backgrounds")
                .ignoresSafeArea()
            VStack {
                Section {
                    Text("Datos de salud")
                        .bold()
                        .font(.largeTitle)
                        .padding(.top, 20)
                }
                
              /*/  List(healthData) { data in
                    NavigationLink {
                        HealthDataDetailView(AHealthData: data)
                    } label: {
                        Cell(oneHealthData: data)
                    } */
            }
        }
    }
}

struct Cell: View {
    var oneHealthData : PersonalizedHealthDataRequest
    
    var body: some View {
        VStack {
            Text(oneHealthData.name)
        }
    }
}

struct HealthDataDetails_Previews: PreviewProvider {
    static var previews: some View {
        HealthDataDetails()
    }
}
