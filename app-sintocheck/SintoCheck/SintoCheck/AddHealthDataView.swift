//
//  AddHealthDataView.swift
//  perfil-SintoCheck
//
//  Created by Andrea Badillo on 10/16/23.
//

import SwiftUI

struct AddHealthDataView: View {
    let rojo = Color(red: 148/255, green: 28/255, blue: 47/255)
    let azul = Color(red: 26/255, green: 26/255, blue: 102/255)
    let verde = Color(red: 168/255, green: 183/255, blue: 171/255)
    @State var modifyList = false
    var body: some View {
        VStack{
            Image(systemName: "pin.circle.fill")
                .resizable()
                .frame(width: 120, height: 120)
                .padding(.bottom, 50)
                .foregroundColor(verde)
            Text("Parece que no cuentas con datos a seguir...")
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
            .fullScreenCover(isPresented: $modifyList) {
                ModifyHealthDataListView()
            }
            .background(azul)
            .cornerRadius(10)
            .padding(.top, 25)
        }
    }
}

struct AddHealthDataView_Previews: PreviewProvider {
    static var previews: some View {
        AddHealthDataView()
    }
}

//#Preview {
//    AddHealthDataView()
//}
