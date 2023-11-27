//
//  NoTrackedHealthDataView.swift
//  SintoCheck
//
//  Created by Alumno on 22/11/23.
//

import SwiftUI

struct NoTrackedHealthDataView: View {
    
    @Binding var standardList : [HealthDataResponse]?
    @Binding var personalizedList : [HealthDataResponse]?
    
        let rojo = Color(red: 148/255, green: 28/255, blue: 47/255)
        let azul = Color(red: 26/255, green: 26/255, blue: 102/255)
        let verde = Color(red: 168/255, green: 183/255, blue: 171/255)
    
        @State var modifyList = false
    
        var body: some View {
            VStack {
                Image("Logo Chiquito")
                    .resizable()
                    .frame(width: 50, height: 50)

                Divider()
                    .background(Color(red: 26/255, green: 26/255, blue: 102/255))
                    .frame(width: 390, height: 1)
                Spacer()
                VStack{
                    Image(systemName: "pin.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .padding(.bottom, 50)
                        .foregroundColor(verde)
                    Text("Parece que no cuentas con datos en favoritos...")
                        .font(.headline)
                        .padding(.bottom, 25)
                    Button(action: {
                        modifyList = true
                    }){
                        Text("Agregar Datos")
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 200)
                    }
                    .background(azul)
                    .cornerRadius(10)
                    .fullScreenCover(isPresented: $modifyList) {
                        ModifyHealthDataListView(healthData: HealthDataResponse(id: "6525e53c250bcddf903d32d5", name: "Tos", quantitative: false, patientId: "1", rangeMin: 1, rangeMax: 10, unit: "", tracked: false, createdAt: ""), standardList: $standardList, personalizedList: $personalizedList)
                    }
                    .padding(.bottom, 250)
                }
            }
        }
    }

struct NoTrackedHealthDataView_Previews: PreviewProvider {
    static var previews: some View {
    @State var previewHealthData: [HealthDataResponse]? = [
        HealthDataResponse(id: "6525e53c250bcddf903d32d5", name: "Tos", quantitative: false, patientId: "1", rangeMin: 1, rangeMax: 10, unit: "", tracked: false, createdAt: ""),
        HealthDataResponse(id: "6525e53c250bcddf903d32d5", name: "Tos", quantitative: false, patientId: "1", rangeMin: 1, rangeMax: 10, unit: "", tracked: false, createdAt: "")
    ]
        NoTrackedHealthDataView(standardList: $previewHealthData, personalizedList: $previewHealthData)
    }
}
