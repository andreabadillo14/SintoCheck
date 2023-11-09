//
//  DoctorPatientRelationshipRequest.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/8/23.
//

import Foundation

class DoctorPatientRelationshipRequest: Codable {
    var doctorId: Int
    var patientId: Int
    
    init(doctorId: Int, patientId: Int) {
        self.doctorId = doctorId
        self.patientId = patientId
    }
}
