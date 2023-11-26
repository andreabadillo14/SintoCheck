//
//  individualNote.swift
//  verNotas
//
//  Created by Sebastian on 24/11/23.
//

import SwiftUI




struct individualNote: View {
    //obtener de la view de arriba un Binding con la nota Note
    var currentNote : Note
    @State private var showSure: Bool = false
    @Binding var patientData : AuthenticationResponse?
    @Environment(\.dismiss) var dismiss
    @Binding var deletedNote: Bool
    
    struct TextView: UIViewRepresentable {
        var text: String
        
        func makeUIView(context: Context) -> UITextView {
            let textView = UITextView()
            textView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title2)
            textView.textAlignment = .justified
            textView.isEditable = false
            //esto tal vez quitarlos
            textView.isSelectable = false
            textView.backgroundColor = UIColor(Color(red: 236/255, green: 239/255, blue: 235/255))

            return textView
        }
        
        func updateUIView(_ uiView: UITextView, context: Context) {
            uiView.text = text
        }
    }
    
    var body: some View {
        ZStack {
            Color(red: 236/255, green: 239/255, blue: 235/255)
                .ignoresSafeArea()
            VStack {
                    VStack {
                        Text(currentNote.title)
                            .font(.largeTitle)
                            .bold()
                        HStack {
        //                    Spacer()
                            Text("Registrado el: ")
                            Spacer()
                            Text("10/02/2023")
        //                    Spacer()
                        }.padding()
                    }
                    
                    TextView(text: currentNote.content)
                        .padding()
                        .font(.system(size: 30))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Button {
                        showSure = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                            //cambiar al rojo de la aplicacion
                                .foregroundColor(Color(red: 148/255, green: 28/255, blue: 47/255))
                                .frame(height: 50)
                            Text("Eliminar nota")
                                .foregroundColor(Color(red: 236/255, green: 239/255, blue: 235/255))
                                .bold()
                        }
                    }.padding()
            }.alert(isPresented: $showSure) {
                Alert(
                    title: Text("Estas seguro de que quieres eliminar esta nota?"), message: Text(""),
                    primaryButton: .default(
                        Text("cancelar"),
                        action: {}
                    ),
                    secondaryButton: .destructive(
                        Text("Eliminar"),
                        action: {
                            if let patientData = patientData {
                                deleteNote(noteId: currentNote.id, patientToken: patientData.token) { note in
                                    
                                    //hacer dismiss y activar la otra nota
                                    deletedNote = true
                                }
                                dismiss()
                            }
                            
                        }
                        //aqui poner codigo para borrar (if let patientData = patientData, etc.)
                    )
                )
            }
        }
        
            
        
    }
}

//#Preview {
//    individualNote(currentNote: <#Binding<Note?>#>)
//}
