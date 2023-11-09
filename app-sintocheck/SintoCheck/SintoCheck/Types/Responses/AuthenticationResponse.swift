//
//  AuthenticationResponse.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 11/8/23.
//

import Foundation

class AuthenticationResponse: Codable {
    var token: String
    var id: Int
    var name: String
    var phone: String
}
