//
//  PatientSignupRequest.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/8/23.
//

import Foundation

class PatientSignupRequest: Codable {
    var name: String
    var phone: String
    var password: String
    var birthdate: String
    var height: Float
    var weight: Float
    var medicine: String
    var medicalBackground: String
    
    init(name: String, phone: String, password: String, birthdate: String, height: Float, weight: Float, medicine: String, medicalBackground: String) {
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
