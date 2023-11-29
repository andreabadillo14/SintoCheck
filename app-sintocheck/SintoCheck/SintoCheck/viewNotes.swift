//
//  VIewNotesList.swift
//  verNotas
//
//  Created by Sebastian on 24/11/23.
//

import SwiftUI


extension UICollectionReusableView {
    override open var backgroundColor: UIColor? {
        get { .clear }
        set { }

    }
}
struct viewNotes: View {
    @State var notes: [Note]?
    @State var notesVacia: [Note] = []
    @State private var showSure: Bool = false
    @Namespace var namespace
    @State var show = false
    @State var patientData : AuthenticationResponse?
    @State var deletedNote = false
    
    func formattedDate(_ dateString: String) -> String {
        return String(dateString.prefix(10))
    }


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
    init() {
            UICollectionView.appearance().backgroundColor = .clear
        }
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color(red: 236/255, green: 239/255, blue: 235/255)
                    .ignoresSafeArea()
                VStack {
                    Image(systemName: show ? "pencil.and.list.clipboard" : "list.clipboard")
                            .resizable()
                            .frame(width: show ? 90 : 70, height: 100)
                            .padding()
                            .matchedGeometryEffect(id: "ID", in: namespace)
                            .rotationEffect(Angle(degrees: show ? 25 : 0))
                            .foregroundColor(Color(red: 148/255, green: 28/255, blue: 47/255))
                    
                    
                    ZStack {
                        
                    }
                    List (notes ?? notesVacia){ note in
                        NavigationLink {
                            individualNote(currentNote: note, patientData: $patientData, deletedNote: $deletedNote)
                        } label: {
                            VStack(spacing: 15) {
                                HStack {
                                    if (note.title.count > 20) {
                                        Text(String(note.title.prefix(20)) + "...")
                                            .font(.title2)
                                            .bold()
                                    }else {
                                        Text(note.title)
                                            .font(.title2)
                                            .bold()
                                    }
                                    
                                    Spacer()
                                }
                                HStack {
                                    if (note.content.count > 30) {
                                        Text(String(note.content.prefix(28)) + "...")
                                    } else {
                                        Text(note.content)
                                    }
                                    Spacer()
                                }
                                HStack {
                                    Text(formattedDate(note.createdAt))
                                    Spacer()
                                }

                                    
                                
                            }

                            
                        }
                        .listRowBackground(Color(red: 226/255, green: 195/255, blue: 145/255))

                    }
                    .scrollContentBackground(.visible)
                    .navigationTitle("Notas Registradas")
                    
                    .alert(isPresented: $deletedNote) {
                        Alert(
                            title: Text("Se elimino la nota"),
                            dismissButton: .default(
                                Text("ok"),
                                action: {
                                    if let patientData = patientData {
                                        fetchNote(patientId: patientData.id, patientToken: patientData.token) { notes in
                                            self.notes = notes
                                        }
                                    }
                                }
                            )
                        )
                    }

                }
            }
        }.onAppear(perform: {
            handlePatientData()
            if let patientData = patientData {
                fetchNote(patientId: patientData.id, patientToken: patientData.token) { notes in
                    self.notes = notes
                    withAnimation {
                        show = true
                    }
                }
            }
            
        })
        
    }
}

#Preview {
    viewNotes()
}
