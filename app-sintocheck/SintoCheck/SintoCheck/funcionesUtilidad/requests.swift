//
//  requests.swift
//  SintoCheck
//
//  Created by Sebastian on 20/11/23.


// TODO: obtener patientID y token del paciente del request en ProfileView

import Foundation
import SwiftUI
//para view de MedicalLinkView
func makeLink(doctorCodigo: String, patientId: String, patientToken: String, completion: @escaping (Doctor?) -> Void) {
    //obtener id del usuario que inicio sesion esta hardcodeado ahora
    guard let url = URL(string: "https://sintocheck-backend.vercel.app/doctorPatientRelationship") else {return}
    var request = URLRequest(url: url)
    //obtener token del inicio de sesion esta hardcodeado ahora.
    request.addValue(patientToken, forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let bodyData = [
        //tomar doctorId como parametro a la funcion
        "doctorCode" : doctorCodigo,
        "patientId" : patientId
    ]
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: bodyData, options: [])
    } catch {
        print("Error encoding data: \(error)")
    }


    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
        }
        if let response = response {
            print("Response: \(response)")
        }
        if let data = data {
            do {
                let decoder = JSONDecoder()
                let doctoresAPI = try decoder.decode(Doctor.self, from: data)
                print("Data: \(doctoresAPI)")
                completion(doctoresAPI)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }
    }.resume()
}


//para view de addNotes.

//estoy seguro que todos estos requests se pueden manejar como una sola funcion en lugar de estar haciendo copy paste como lo hago, pero no se como tomar el tipo de dato como parametro entonces por ahora lo hago asi.
func addNoteAPI(title: String, content: String, completion: @escaping (Note?) -> Void) {
    //obtener id del usuario que inicio sesion esta hardcodeado ahora
    guard let url = URL(string: "https://sintocheck-backend.vercel.app/note") else {return}
    var request = URLRequest(url: url)
    //obtener token del inicio de sesion esta hardcodeado ahora.
    request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1NWQyZTY1ZmUyMmVmNjViODNjOTRlMCIsIm5hbWUiOiJwYWNpZW50ZSBQcnVlYmEiLCJwaG9uZSI6IjEyMzQ0MzIxIiwiaWF0IjoxNzAwNjA1NTUwLCJleHAiOjE3MDE4MTUxNTB9.54PgoD0Vd8xLPWltOAXSDW7iCJGFaRUo-TQANmrPw9k", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let bodyData = [
        //tomar doctorId como parametro a la funcion
        "title" : title,
        "content" : content,
        //obtener del login no hardcodeado como ahora.
        "patientId" : "655d2e65fe22ef65b83c94e0"
    ]
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: bodyData, options: [])
    } catch {
        print("Error encoding data: \(error)")
    }

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
        }
        if let response = response {
            print("Response: \(response)")
        }
        if let data = data {
            do {
                let decoder = JSONDecoder()
                let doctoresAPI = try decoder.decode(Note.self, from: data)
                print("Data: \(doctoresAPI)")
                completion(doctoresAPI)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }
    }.resume()
}

//para view DoctorDetailsView
func fetchDoctor(patientId: String, patientToken: String, completion: @escaping ([Doctor]?) -> Void) {
    //obtener id del usuario que inicio sesion esta hardcodeado ahora
    guard let url = URL(string: "https://sintocheck-backend.vercel.app/doctorPatientRelationship/\(patientId)") else {return}
    var request = URLRequest(url: url)
    //obtener token del inicio de sesion esta hardcodeado ahora.
    request.addValue(patientToken, forHTTPHeaderField: "Authorization")
    request.httpMethod = "GET"

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
        }
        if let response = response {
            print("Response: \(response)")
        }
        if let data = data {
            do {
                let decoder = JSONDecoder()
                let doctoresAPI = try decoder.decode([Doctor].self, from: data)
                print("Data: \(doctoresAPI)")
                completion(doctoresAPI)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }
    }.resume()
}

func deleteDoctor(doctorId: String, patientId: String, patientToken: String, completion: @escaping (Doctor?) -> Void) {
    //obtener id del usuario que inicio sesion esta hardcodeado ahora
    guard let url = URL(string: "https://sintocheck-backend.vercel.app/doctorPatientRelationship") else {return}
    var request = URLRequest(url: url)
    //obtener token del inicio de sesion esta hardcodeado ahora.
    request.addValue(patientToken, forHTTPHeaderField: "Authorization")
    request.httpMethod = "DELETE"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let bodyData = [
        //tomar doctorId como parametro a la funcion?
        "doctorId" : doctorId,
        //obtener del login no hardcodeado como ahora.
        "patientId" : patientId,
    ]
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: bodyData, options: [])
    } catch {
        print("Error encoding data: \(error)")
    }

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
        }
        if let response = response {
            print("Response: \(response)")
        }
        if let data = data {
            do {
                let decoder = JSONDecoder()
                let doctoresAPI = try decoder.decode(Doctor.self, from: data)
                print("Data: \(doctoresAPI)")
                completion(doctoresAPI)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }
    }.resume()
}

//para view ProfileView
func sendImage(image: UIImage, patientId: String, patientToken: String, completion: @escaping () -> Void) {
    guard let url = URL(string: "https://api-text.vercel.app/image") else { return }
    let boundary = UUID().uuidString
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    // Add Authorization Header
    request.addValue(patientToken, forHTTPHeaderField: "Authorization")
    
//    // Add Body
//    let patientId = "655bfeae88807f60971b9d27"
//    let bodyData = "patientId=\(patientId)".data(using: .utf8)
    
    // Set Content-Type and Boundary for multipart/form-data
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    var body = Data()
    //agrego el id del paciente
    body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"patientId\"\r\n\r\n".data(using: .utf8)!)
    body.append(patientId.data(using: .utf8)!)
    
    //agrego la imagen
    body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"image\"; filename=\"seb.jpg\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
    
    if let imageData = image.jpegData(compressionQuality: 0.99) {
        body.append(imageData)
    }
    
    body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
    
    request.httpBody = body
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if error == nil, let data = data {
            if let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                if let json = jsonData as? [String: Any] {
                    print(json)
                    
                }
            }
        }
        completion() // Call completion on success

    }.resume()
}

//cuando image url este en el api borrar esto y obtener el url del api
func fetchImage(patientId: String, patientToken: String, completion: @escaping (ImageAPI?) -> Void) {
    //obtener id del usuario que inicio sesion esta hardcodeado ahora
    guard let url = URL(string: "https://api-text.vercel.app/image/\(patientId)") else {return}
    var request = URLRequest(url: url)
    //obtener token del inicio de sesion esta hardcodeado ahora.
    request.addValue(patientToken, forHTTPHeaderField: "Authorization")
    request.httpMethod = "GET"

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
        }
        if let response = response {
            print("Response: \(response)")
        }
        if let data = data {
            do {
                let decoder = JSONDecoder()
                let doctoresAPI = try decoder.decode(ImageAPI.self, from: data)
                print("Data: \(doctoresAPI)")
                completion(doctoresAPI)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }
    }.resume()
}

