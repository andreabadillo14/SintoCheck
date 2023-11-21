//
//  PatientUpdateRequest.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/8/23.
//

import Foundation

class PatientUpdateRequest: Codable {
    var name: String
    var phone: String
    var birthdate: String
    var height: Double
    var weight: Double
    var medicine: String
    var medicalBackground: String
    
    init(name: String, phone: String, birthdate: String, height: Double, weight: Double, medicine: String, medicalBackground: String) {
        self.name = name
        self.phone = phone
        self.birthdate = birthdate
        self.height = height
        self.weight = weight
        self.medicine = medicine
        self.medicalBackground = medicalBackground
    }
}
