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
                    Image("Logo Chiquito")
                        .resizable()
                        .frame(width: 50, height: 50)

                    Divider()
                        .background(Color(red: 26/255, green: 26/255, blue: 102/255))
                        .frame(width: 390, height: 1)
                    
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
            }
                .foregroundColor(Color(red: 26/255, green: 26/255, blue: 102/255))
            .fullScreenCover(isPresented: $editView, content: {
                ModifyHealthDataListView(healthData: HealthDataResponse(id: "", name: "", quantitative: false, patientId: "1", rangeMin: 1, rangeMax: 10, unit: "", tracked: false, createdAt: ""), standardList: $standardList, personalizedList: $personalizedList)
            }))
            .navigationBarItems(leading: Button("Perfil"){
               backView = true
            }
                .foregroundColor(Color(red: 26/255, green: 26/255, blue: 102/255))
            .fullScreenCover(isPresented: $backView, content: {
                SwitchView()
            }))
        }
    }
}


struct AddDataRecordListView_Previews: PreviewProvider {
    @State static var previewHealthData: [HealthDataResponse]? = [
        HealthDataResponse(id: "6525e53c250bcddf903d32d5", name: "Tos", quantitative: false, patientId: "1", rangeMin: 1, rangeMax: 10, unit: "", tracked: false, createdAt: ""),
        HealthDataResponse(id: "6525e53c250bcddf903d32d5", name: "Tos", quantitative: false, patientId: "1", rangeMin: 1, rangeMax: 10, unit: "", tracked: false, createdAt: "")
    ]

    static var previews: some View {
        AddDataRecordListView(standardList: $previewHealthData, personalizedList: $previewHealthData, healthData: HealthDataResponse(id: "", name: "", quantitative: false, patientId: "", rangeMin: 0.0, rangeMax: 0.0, unit: "", tracked: false, createdAt: ""))
    }
}

