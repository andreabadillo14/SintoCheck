//
//  NoteResponse.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/8/23.
//

import Foundation

class NoteResponse: Codable {
    var id: Int
    var title: String
    var content: String
    var patientId: Int
}
