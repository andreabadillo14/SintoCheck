//
//  HealthDataDetails.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 10/17/23.
//

import SwiftUI

struct HealthDataDetails: View {
    @Binding var isDismissed: Bool
    @Environment(\.dismiss) var dismiss

    var healthData = [
        PersonalizedHealthDataRequest(id: UUID(), name: "Tos", quantitative: false, patientId: 1, rangeMin: 1, rangeMax: 10, unit: "n/a"),
        PersonalizedHealthDataRequest(id: UUID(), name: "Fiebre", quantitative: true, patientId: 1, rangeMin: 35, rangeMax: 42, unit: "C"),
        PersonalizedHealthDataRequest(id: UUID(), name: "Glucosa", quantitative: true, patientId: 1, rangeMin: 80, rangeMax: 150, unit: "mg/dL")
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
                
                List(healthData) { data in
                    NavigationLink {
                        HealthDataDetailView(AHealthData: data)
                    } label: {
                        Cell(oneHealthData: data)
                    }
                }
            }
        }.onChange(of: isDismissed) { oldValue, newValue in
            if oldValue != newValue {
                dismiss()
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
        HealthDataDetails(isDismissed: .constant(false))
    }
}
