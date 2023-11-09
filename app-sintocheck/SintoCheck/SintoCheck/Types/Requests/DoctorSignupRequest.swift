//
//  DoctorSignupRequest.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/8/23.
//

import Foundation

class DoctorSignupRequest: Codable {
    var name: String
    var phone: String
    var password: String
    var speciality: String
    var address: String
    
    init(name: String, phone: String, password: String, speciality: String, address: String) {
        self.name = name
        self.phone = phone
        self.password = password
        self.speciality = speciality
        self.address = address
    }
}
