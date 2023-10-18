//
//  HealthData.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 10/18/23.
//

import Foundation

class HealthData : Identifiable {
    var id : UUID = UUID()
    var patientId : Int // esto es por mientras
    var name : String
    var quantitative : Bool
    // hay que checar estas partes que son opcionales
    var rangeMin : Float
    var rangeMax : Float
    var units : String
    
    init(patientId: Int, name: String, quantitative: Bool, rangeMin: Float, rangeMax: Float, units: String) {
        self.patientId = patientId
        self.name = name
        self.quantitative = quantitative
        self.rangeMin = rangeMin
        self.rangeMax = rangeMax
        self.units = units
    }
}
