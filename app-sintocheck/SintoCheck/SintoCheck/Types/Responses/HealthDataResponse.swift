//
//  HealthDataResponse.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/8/23.
//

import Foundation

class HealthDataResponse: Codable {
    var id: Int
    var name: String
    var quantitative: Bool
    var patientId: Int?
    var rangeMin: Double
    var rangeMax: Double
    var unit: String
}
