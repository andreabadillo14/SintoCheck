//
//  utils.swift
//  SintoCheck
//
//  Created by Alumno on 20/11/23.
//

import Foundation

enum FileReaderError: Error {
    case fileNotFound
    case fileReadError
}

func getPatientData() throws -> AuthenticationResponse {
    // Retrieve the file URL
    let sandboxURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = sandboxURL.appendingPathComponent("loginResponse.json")

    // Check if the file exists
    let fileManager = FileManager.default
    
    if !fileManager.fileExists(atPath: fileURL.path) {
        // File does not exist, handle this case accordingly
        print("file not found")
        fatalError("Could not find login response file")
    }

    // Read the file contents
    if let data = fileManager.contents(atPath: fileURL.path) {
        // Decode the JSON data into a PatientSignupResponse object
        let decodedData = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
        return decodedData
    } else {
        // Handle the error if the file cannot be read
        //fatalError("Error reading login response file")
        throw FileReaderError.fileNotFound
    }
}
