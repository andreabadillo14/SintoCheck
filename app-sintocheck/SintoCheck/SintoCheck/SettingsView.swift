import SwiftUI

struct SettingsView: View {
    @State private var mostrarAlertaCerrarSesion = false
    @State private var cerrarSesion = false
    @State var patientData = AuthenticationResponse()
    let azul = Color(red: 26/255, green: 26/255, blue: 102/255)

    var body: some View {
        VStack {
            Text("Ajustes")
                .font(.largeTitle)
                .padding()

            Button("Cerrar Sesión") {
                mostrarAlertaCerrarSesion = true
            }
            .padding()
            .foregroundColor(.white)
            .background(azul)
            .cornerRadius(8)
        }
        .alert("¿Cerrar sesión?", isPresented: $mostrarAlertaCerrarSesion) {
            Button("Cancelar", role: .cancel) {}
            Button("Aceptar", role: .destructive) {
                cerrarSesion = true
            }
        } message: {
            Text("¿Estás seguro de que quieres cerrar sesión?")
        }
        .fullScreenCover(isPresented: $cerrarSesion) {
            LoginView()
        }
        .onAppear {
            Task{
                do {
                    patientData = try getPatientData()
                } catch let error as FileReaderError {
                    print(error)
                    switch error {
                    case .fileNotFound:
                        print("not found")
                    case .fileReadError:
                        print("read error")
                    }
                } catch {
                    print("unknown: \(error)")
                }
            }
         }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
