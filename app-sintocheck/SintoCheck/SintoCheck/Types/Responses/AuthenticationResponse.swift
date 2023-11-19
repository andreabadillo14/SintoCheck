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
}
