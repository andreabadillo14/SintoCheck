//
//  DoctorPatientRelationshipResponse.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/8/23.
//

import Foundation

class DoctorPatientRelationshipResponse: Codable {
    var id: Int
    var name: String
    var phone: String
    var speciality: String
    var address: String
}
