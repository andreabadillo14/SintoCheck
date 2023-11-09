//
//  PatientSignupRequest.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/8/23.
//

import Foundation

class PatientSignupRequest: Codable, Identifiable {
    var id : UUID = UUID()
    var name: String
    var phone: String
    var password: String
    var birthdate: String
    var height: Double
    var weight: Double
    var medicine: String
    var medicalBackground: String
    
    init(id: UUID, name: String, phone: String, password: String, birthdate: String, height: Double, weight: Double, medicine: String, medicalBackground: String) {
        self.id = id
        self.name = name
        self.phone = phone
        self.password = password
        self.birthdate = birthdate
        self.height = height
        self.weight = weight
        self.medicine = medicine
        self.medicalBackground = medicalBackground
    }
}
