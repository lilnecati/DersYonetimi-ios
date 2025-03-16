import SwiftUI

struct DersDuzenleView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var studentManager: StudentManager
    let ogrenciIndex: Int
    let dersIndex: Int
    let ders: Ders
    
    @State private var vizeNotu: String = ""
    @State private var finalNotu: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Ders Bilgileri")) {
                    Text("Ders: \(ders.ad)")
                    Text("Kod: \(ders.kod)")
                }
                
                Section(header: Text("Not Bilgileri")) {
                    TextField("Vize Notu", text: $vizeNotu)
                        .keyboardType(.decimalPad)
                    TextField("Final Notu", text: $finalNotu)
                        .keyboardType(.decimalPad)
                }
                
                if let vize = Double(vizeNotu), let final = Double(finalNotu) {
                    Section(header: Text("Hesaplanan Notlar")) {
                        let ortalama = (vize * 0.4 + final * 0.6).rounded(to: 2)
                        Text("Ortalama: \(String(format: "%.2f", ortalama))")
                        Text("Harf Notu: \(hesaplaHarfNotu(ortalama))")
                            .foregroundColor(Theme.harfNotuRengi(hesaplaHarfNotu(ortalama)))
                    }
                }
            }
            .navigationTitle("Not Düzenle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        kaydet()
                    }
                }
            }
            .onAppear {
                if let vize = ders.vizeNotu {
                    vizeNotu = String(format: "%.1f", vize)
                }
                if let final = ders.finalNotu {
                    finalNotu = String(format: "%.1f", final)
                }
            }
            .alert("Hata", isPresented: $showingAlert) {
                Button("Tamam", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func kaydet() {
        // Boş değerleri nil olarak kabul et
        let vize: Double? = vizeNotu.isEmpty ? nil : Double(vizeNotu)
        let final: Double? = finalNotu.isEmpty ? nil : Double(finalNotu)
        
        // Değerler girilmişse geçerlilik kontrolü yap
        if let vize = vize {
            guard vize >= 0 && vize <= 100 else {
                alertMessage = "Vize notu 0-100 arasında olmalıdır"
                showingAlert = true
                return
            }
        }
        
        if let final = final {
            guard final >= 0 && final <= 100 else {
                alertMessage = "Final notu 0-100 arasında olmalıdır"
                showingAlert = true
                return
            }
        }
        
        studentManager.notGuncelle(ogrenciIndex: ogrenciIndex, dersIndex: dersIndex, vizeNotu: vize, finalNotu: final)
        dismiss()
    }
    
    private func hesaplaHarfNotu(_ not: Double) -> String {
        switch not {
        case 90...100: return "AA"
        case 85..<90: return "BA"
        case 80..<85: return "BB"
        case 75..<80: return "CB"
        case 70..<75: return "CC"
        case 65..<70: return "DC"
        case 60..<65: return "DD"
        case 50..<60: return "FD"
        case 0..<50: return "FF"
        default: return "-"
        }
    }
}

extension Double {
    func isInRange(_ range: ClosedRange<Double>) -> Bool {
        return range.contains(self)
    }
}

#Preview {
    DersDuzenleView(
        ogrenciIndex: 0,
        dersIndex: 0,
        ders: Ders(id: UUID(), kod: "TEST101", ad: "Test Dersi", kredi: 3, akts: 5, donem: 1, vizeNotu: 90, finalNotu: 85)
    )
    .environmentObject(StudentManager())
} 



// deneme
