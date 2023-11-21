//
//  HealthDataResponse.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/8/23.
//

import Foundation

class HealthDataResponse: Codable {
    var id: String
    var name: String
    var quantitative: Bool
    var patientId: String?
    var rangeMin: Double
    var rangeMax: Double
    var unit: String
    
    init(id: String, name: String, quantitative: Bool, patientId: String? = nil, rangeMin: Double, rangeMax: Double, unit: String) {
        self.id = id
        self.name = name
        self.quantitative = quantitative
        self.patientId = patientId
        self.rangeMin = rangeMin
        self.rangeMax = rangeMax
        self.unit = unit
    }
}
