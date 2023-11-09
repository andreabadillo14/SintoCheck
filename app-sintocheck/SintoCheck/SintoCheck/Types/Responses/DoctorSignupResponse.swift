//
//  DoctorSignupResponse.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/8/23.
//

import Foundation

class DoctorSignupResponse: Codable {
    var id: Int
    var name: String
    var phone: String
    var speciality: String
    var address: String
}
