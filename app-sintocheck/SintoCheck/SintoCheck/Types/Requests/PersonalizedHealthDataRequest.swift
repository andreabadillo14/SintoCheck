//
//  PersonalizedHealthDataRequest.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/8/23.
//

import Foundation

class PersonalizedHealthDataRequest : Codable, Identifiable {
    var id : UUID = UUID()
    var name: String
    var quantitative: Bool
    var patientId: Int
    var rangeMin: Double
    var rangeMax: Double
    var unit: String
    
    init(id: UUID, name: String, quantitative: Bool, patientId: Int, rangeMin: Double, rangeMax: Double, unit: String) {
        self.id = id
        self.name = name
        self.quantitative = quantitative
        self.patientId = patientId
        self.rangeMin = rangeMin
        self.rangeMax = rangeMax
        self.unit = unit
    }
}
