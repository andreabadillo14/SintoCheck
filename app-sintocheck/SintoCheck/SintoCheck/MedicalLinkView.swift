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
            GeometryReader { geometry in
                VStack {
                    Image("Logo Chiquito")
                        .resizable()
                        .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.08)

                    Divider()
                        .background(Color(red: 26/255, green: 26/255, blue: 102/255))
                        .frame(width: geometry.size.width * 1, height: 1)
                    
                    Text("Enlace con su médico")
                        .bold()
                        .font(.title)
                        .padding(.horizontal, geometry.size.width * 0.05)
                    Spacer()
                    fullCodeField(codeString: $doctorCode)
                        .padding(.horizontal, geometry.size.width * 0.05)
                    Spacer()
                    HStack {
                        Spacer()
                        Button  {
                            if (doctorCode != "" && doctorCode.isAlphanumeric) {
                                makeLink(doctorCodigo: doctorCode) { doctor in
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
                                    .frame(width: geometry.size.width * 0.55, height: geometry.size.height * 0.065)
                                Text("Registrar doctor")
                                    .foregroundColor(Color(red: 236/255, green: 239/255, blue: 235/255))
                                    .bold()
                                    .frame(width: geometry.size.width * 0.55, height: geometry.size.height * 0.055, alignment: .center)
                            }
                        }
                        .padding()
                        //.frame(height:80)
                        .alert(alertValidationMessage, isPresented: $alertValidation, actions: {
                            
                        })
                        Spacer()
                    }
                    Spacer()
                }
            }
            //.navigationTitle("Enlace con su medico")
        }.onTapGesture {
            UIApplication.shared.endEditing()
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
