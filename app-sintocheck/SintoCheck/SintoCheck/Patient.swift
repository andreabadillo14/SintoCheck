//
//  Patient.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 10/19/23.
//

import Foundation

class Patient {
    var id : UUID = UUID()
    var birthdate = Date()
    var height : Float
    var weight : Float
    var medicine : String
    var medicalBackground : String
    
    init(id: UUID, birthdate: Date = Date(), height: Float, weight: Float, medicine: String, medicalBackground: String) {
        self.id = id
        self.birthdate = birthdate
        self.height = height
        self.weight = weight
        self.medicine = medicine
        self.medicalBackground = medicalBackground
    }
}
