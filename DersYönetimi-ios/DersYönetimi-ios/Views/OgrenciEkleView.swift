import SwiftUI

struct OgrenciEkleView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var studentManager: StudentManager
    
    @State private var adSoyad = ""
    @State private var ogrenciNo = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var isFormValid: Bool {
        !adSoyad.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !ogrenciNo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Öğrenci Bilgileri")) {
                    TextField("Ad Soyad", text: $adSoyad)
                        .textContentType(.name)
                        .autocapitalization(.words)
                    
                    TextField("Öğrenci No", text: $ogrenciNo)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Yeni Öğrenci")
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
                            studentManager.ogrenciEkle(
                                adSoyad: adSoyad.trimmingCharacters(in: .whitespacesAndNewlines),
                                ogrenciNo: ogrenciNo.trimmingCharacters(in: .whitespacesAndNewlines)
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
    OgrenciEkleView()
        .environmentObject(StudentManager())
} 