//
//  HealthDataNoteDetailView.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/23/23.
//

import SwiftUI

struct HealthDataNoteDetailView: View {
    var note: String = ""
    var value: Double = 0.0
    var dateRegistered: String = ""
    var unit: String = ""
    var dataHealthName: String = ""
    
    func formattedDate(_ dateString: String) -> String {
        return String(dateString.prefix(10))
    }

    var body: some View {
        VStack {
            Text("Detalle de nota sobre \(dataHealthName)")
                .bold()
                .font(.title)
            Spacer()
            HStack {
                let value = String(format: "%.1f %@", value, unit)
                Text(value)
                    .font(.headline)
                    .padding(.leading)
                Spacer()
                Text(formattedDate(dateRegistered))
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    .padding(.bottom, 4)
                let time = dateRegistered.dropFirst(11).prefix(5)
                let timeString = String(time) + " hrs"
                Text(String(timeString))
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    .padding(.trailing, 10)
            }
            
            Text(note)
                .padding()
                //.background(Color.blue.opacity(0.2))
                .background(Color(red: 226/255, green: 195/255, blue: 145/255))
                .cornerRadius(10)
                .padding()
            
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
        //.navigationBarTitle("Detalle de nota sobre dato de salud: \(dataHealthName)")
        .padding(.top, 23)
    }
}

#Preview {
    HealthDataNoteDetailView()
}
