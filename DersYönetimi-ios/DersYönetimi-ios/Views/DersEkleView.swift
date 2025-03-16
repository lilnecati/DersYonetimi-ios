import SwiftUI

struct DersEkleView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var studentManager: StudentManager
    let ogrenciIndex: Int
    let selectedDonem: Int
    
    @State private var dersKodu = ""
    @State private var dersAdi = ""
    @State private var kredi = 3
    @State private var akts = 5
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var isFormValid: Bool {
        !dersKodu.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !dersAdi.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Ders Bilgileri")) {
                    TextField("Ders Kodu", text: $dersKodu)
                        .textContentType(.none)
                        .autocapitalization(.allCharacters)
                    
                    TextField("Ders Adı", text: $dersAdi)
                        .textContentType(.none)
                        .autocapitalization(.words)
                }
                
                Section(header: Text("Kredi ve AKTS")) {
                    Stepper("Kredi: \(kredi)", value: $kredi, in: 1...10)
                    Stepper("AKTS: \(akts)", value: $akts, in: 1...30)
                }
            }
            .navigationTitle("Yeni Ders")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Ekle") {
                        if isFormValid {
                            studentManager.dersEkle(
                                ogrenciIndex: ogrenciIndex,
                                kod: dersKodu.trimmingCharacters(in: .whitespacesAndNewlines),
                                ad: dersAdi.trimmingCharacters(in: .whitespacesAndNewlines),
                                kredi: kredi,
                                akts: akts,
                                donem: selectedDonem
                            )
                            dismiss()
                        } else {
                            alertMessage = "Lütfen tüm alanları doldurun."
                            showingAlert = true
                        }
                    }
                    .disabled(!isFormValid)
                }
            }
            .alert("Hata", isPresented: $showingAlert) {
                Button("Tamam", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}

#Preview {
    DersEkleView(ogrenciIndex: 0, selectedDonem: 1)
        .environmentObject(StudentManager())
} 