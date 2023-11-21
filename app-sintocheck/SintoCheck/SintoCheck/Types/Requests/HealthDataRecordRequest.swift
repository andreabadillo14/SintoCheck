//
//  HealthDataRecordRequest.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/8/23.
//

import Foundation

class HealthDataRecordRequest: Codable {
    var patientId: Int
    var healthDataId: Int
    var value: Double
    var note: String
    
    init(patientId: Int, healthDataId: Int, value: Double, note: String) {
        self.patientId = patientId
        self.healthDataId = healthDataId
        self.value = value
        self.note = note
    }
}
