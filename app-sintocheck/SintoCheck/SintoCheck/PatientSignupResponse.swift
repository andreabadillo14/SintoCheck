//
//  PatientSignupResponse.swift
//  SintoCheck
//
//  Created by Alumno on 17/11/23.
//

import Foundation

class PatientSignupResponse: Codable {
    var id: String
    var name: String
    var phone: String
    var birthdate: String
    var height: Double
    var weight: Double
    var medicine: String
    var medicalBackground: String
}
