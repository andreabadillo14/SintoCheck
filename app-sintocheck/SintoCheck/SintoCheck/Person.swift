//
//  Person.swift
//  SintoCheck
//
//  Created by Andrea Badillo on 10/18/23.
//

import Foundation

class Person : Identifiable {
    var id : UUID = UUID()
    var name : String
    var phone : String // maybe string? o podemos checar otro tipo
    var password : String
    
    init(name: String, phone: String, password: String) {
        self.name = name
        self.phone = phone
        self.password = password
    }
}
