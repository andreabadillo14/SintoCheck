//
//  AuthenticationResponse.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/8/23.
//

import Foundation

class AuthenticationResponse: Codable {
    var id: String
    var name: String
    var phone: String
    var password : String
    var birthdate : String?
    var height : Float?
    var weight : Float?
    var medicine : String?
    var medicalBackground : String?
    var doctorIds : [String]?
    var createdAt : String
    var token: String
    
    init(id: String = "", name: String = "", phone: String = "", password: String = "", birthdate: String? = nil, height: Float? = nil, weight: Float? = nil, medicine: String? = nil, medicalBackground: String? = nil, doctorIds: [String]? = nil, createdAt: String = "", token: String = "") {
        self.id = id
        self.name = name
        self.phone = phone
        self.password = password
        self.birthdate = birthdate
        self.height = height
        self.weight = weight
        self.medicine = medicine
        self.medicalBackground = medicalBackground
        self.doctorIds = doctorIds
        self.createdAt = createdAt
        self.token = token
    }
}
