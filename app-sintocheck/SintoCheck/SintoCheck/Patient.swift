//
//  Patient.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 10/19/23.
//

import Foundation

class Patient : Identifiable {
    var id : UUID = UUID()
    var name : String
    var lastname : String
    var birthdate : String // por mientras
    var height : Float
    var weight : Float
    var medicine : String
    var medicalBackground : String
    
    init(id: UUID, name: String, lastname: String, birthdate: String, height: Float, weight: Float, medicine: String, medicalBackground: String) {
        self.id = id
        self.name = name
        self.lastname = lastname
        self.birthdate = birthdate
        self.height = height
        self.weight = weight
        self.medicine = medicine
        self.medicalBackground = medicalBackground
    }
}
