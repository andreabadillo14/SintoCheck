//
//  DoctorDetails.swift
//  SintoCheck
//
//  Created by Sebastian on 09/11/23.
//
//Cree este archivo porque lo use para la view de DoctorDetails
//pero como en el main no existia no estoy seguro si se necesite.

import Foundation

class DoctorDetails : Identifiable {
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
