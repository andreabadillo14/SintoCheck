//
//  HealthDataDetailView.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/9/23.
//

import SwiftUI
import Charts

struct HealthDataDetailView: View {
    var AHealthData : PersonalizedHealthDataRequest
    var body: some View {
        VStack {
            Text(AHealthData.name)
                .font(.title)
                .bold()
            
            Chart {
                LineMark(x: .value("Dato de salud", AHealthData.name),
                         y: .value("Dato de salud", AHealthData.rangeMax))
            }
            .frame(height: 270)
            .padding()
            
            Text("Notas")
                .bold()
        }
    }
}

#Preview {
    HealthDataDetailView(AHealthData: PersonalizedHealthDataRequest(id: UUID(), name: "Tos", quantitative: false, patientId: 1, rangeMin: 1, rangeMax: 10, unit: "n/a"))
}
