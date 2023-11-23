//
//  HealthDataRecordResponse.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/8/23.
//

import Foundation

class HealthDataRecordResponse: Decodable {
    var id: String
    var patientId: String
    var healthDataId: String
    var value: Double
    var note: String
    var createdAt: String
}
