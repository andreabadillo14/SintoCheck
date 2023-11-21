//
//  PatientSignupResponse.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/8/23.
//

import Foundation

class PatientSignupResponse: Codable {
    var id: Int
    var name: String
    var phone: String
    var birthdate: String
    var height: Double
    var weight: Double
    var medicine: String
    var medicalBackground: String
}
