//
//  MedicalLinkView.swift
//  SintoCheck
//
//  Created by Sebastian on 08/11/23.
//

import SwiftUI

struct MedicalLinkView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State var doctorCode = ""
    @Binding var exito : Bool
    @Binding var mensajeLink : String
    @State var doctor: Doctor?
    @State var doctorNombre = ""
    @State private var alertValidation = false
    @State private var alertValidationMessage = ""
    
    //los tenia como binding, ahorita si esot hace todo lo que quiera regresarlo a binding
    @State var patientData : AuthenticationResponse?



    func handlePatientData() {
        do {
            let sandboxURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = sandboxURL.appendingPathComponent("loginResponse.json")

            if !FileManager.default.fileExists(atPath: fileURL.path) {
                // File does not exist, handle this case accordingly
                print("Login response file not found")
                return
            }

            patientData = try getPatientData()
        } catch let error {
            print("An error occurred while retrieving patient data: \(error)")
        }
    }
    
    private enum Field: Int, CaseIterable {
        case field1, field2, field3, field4, field5, field6, field7, field8
    }
    private func textFieldDidChange(_ text: String, for field: Field) {
      if text.isEmpty {
          focusedField = Field(rawValue: field.rawValue - 1)
      } else if text.count > 1 {
          focusedField = Field(rawValue: field.rawValue + 1)
      }
    }

    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                fullCodeField(codeString: $doctorCode)
                .padding(.horizontal, 20)
                Spacer()
                HStack {
                    Spacer()
                    Button  {
                        if (doctorCode != "" && doctorCode.isAlphanumeric) {
                            if let patientData = patientData {
                                makeLink(doctorCodigo: doctorCode, patientId: patientData.id, patientToken: patientData.token) { doctor in
                                    self.doctor = doctor
                                    //checar si existe el doctor que obtuve
                                    if let doctor = doctor {
                                        exito = true
                                        mensajeLink = "Se registro exitasomanete el doctor \(doctor.name)"
                                    } else {
                                        exito = true
                                        mensajeLink = "No se pudo registrar el doctor"
                                    }
                                }
                                dismiss()
                            }
                            
                        } else {
                            if (doctorCode == "") {
                                alertValidation = true
                                alertValidationMessage = "introduce un codigo"
                            } else if (!doctorCode.isAlphanumeric) {
                                alertValidation = true
                                alertValidationMessage = "introduce un código valido"
                            }
                            
                        }
                        
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(red: 26/255, green: 26/255, blue: 102/255))
                            Text("Registrar doctor")
                                .foregroundColor(Color(red: 236/255, green: 239/255, blue: 235/255))
                                .bold()
                        }
                    }
                    .padding()
                    .frame(height:80)
                    .alert(alertValidationMessage, isPresented: $alertValidation, actions: {
                        
                    })
                    Spacer()
                }
                Spacer()
            }
            .navigationTitle("Enlace con su medico")
        }.onTapGesture {
            UIApplication.shared.endEditing()
        }.onAppear {
            handlePatientData()
        }
    }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    MedicalLinkView(exito: .constant(false), mensajeLink: .constant("doctor"))
}
