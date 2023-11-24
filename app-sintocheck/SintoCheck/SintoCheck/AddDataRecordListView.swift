//
//  AddDataRecordListView.swift
//  SintoCheck
//
//  Created by Alumno on 22/11/23.
//

import SwiftUI

struct AddDataRecordListView: View {
    @Binding var standardList : [HealthDataResponse]?
    @Binding var personalizedList: [HealthDataResponse]?
    @State private var selectedHealthData: HealthDataResponse?
    @State var healthData: HealthDataResponse
    @State var selectedData = false
    @State var editView = false
    @State var backView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Backgrounds").ignoresSafeArea()
                VStack {
                    Text("Registro de Datos")
                        .padding(.top, 15)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 6)

                    if let personalizedList = personalizedList, !personalizedList.isEmpty {
                        List(personalizedList, id: \.id) { elements in
                            Button(action: {
                                self.selectedHealthData = elements
                                healthData = elements
                                selectedData = true
                            }) {
                                Text(elements.name)
                            }
                            .fullScreenCover(isPresented: $selectedData, content: {
                                RegisterHealthDataView(healthData: $healthData)
                            })
                        }
                    } else {
                        NoTrackedHealthDataView(standardList: $standardList, personalizedList: $personalizedList)
                    }
                }
            }
            .navigationBarItems(trailing: Button("Editar") {
                editView = true
            }.fullScreenCover(isPresented: $editView, content: {
                ModifyHealthDataListView(healthData: HealthDataResponse(id: "", name: "", quantitative: false, patientId: "1", rangeMin: 1, rangeMax: 10, unit: ""), standardList: $standardList, personalizedList: $personalizedList)
            }))
            .navigationBarItems(leading: Button("Regresar"){
               backView = true
            }.fullScreenCover(isPresented: $backView, content: {
                SwitchView()
            }))
        }
    }
}


struct AddDataRecordListView_Previews: PreviewProvider {
    @State static var previewHealthData: [HealthDataResponse]? = [
        HealthDataResponse(id: "6525e53c250bcddf903d32d5", name: "Tos", quantitative: false, patientId: "1", rangeMin: 1, rangeMax: 10, unit: ""),
        HealthDataResponse(id: "6525e53c250bcddf903d32d5", name: "Tos", quantitative: false, patientId: "1", rangeMin: 1, rangeMax: 10, unit: "")
    ]

    static var previews: some View {
        AddDataRecordListView(standardList: $previewHealthData, personalizedList: $previewHealthData, healthData: HealthDataResponse(id: "", name: "", quantitative: false, patientId: "", rangeMin: 0.0, rangeMax: 0.0, unit: ""))
    }
}

