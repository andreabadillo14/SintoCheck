//
//  NoteRequest.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/8/23.
//

import Foundation

class NoteRequest: Codable {
    var title: String
    var content: String
    var patientId: Int
    
    init(title: String, content: String, patientId: Int) {
        self.title = title
        self.content = content
        self.patientId = patientId
    }
}
