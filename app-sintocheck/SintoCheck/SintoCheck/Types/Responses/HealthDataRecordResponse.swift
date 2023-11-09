//
//  HealthDataRecordResponse.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/8/23.
//

import Foundation

class HealthDataRecordResponse: Codable {
    var id: Int
    var patientId: Int
    var healthDataId: Int
    var value: Double
    var note: String
}
