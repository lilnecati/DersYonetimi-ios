import SwiftUI

struct DersKartiView: View {
    @EnvironmentObject var studentManager: StudentManager
    let ogrenci: Ogrenci
    let ders: Ders
    @State private var showingDuzenleView = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.CardStyle.spacing) {
            HStack {
                Text(ders.kod)
                    .font(.system(size: Theme.FontSize.headline, weight: .semibold))
                    .foregroundColor(Theme.appColor)
                Spacer()
                Menu {
                    Button(role: .destructive) {
                        if let ogrenciIndex = studentManager.ogrenciler.firstIndex(where: { $0.id == ogrenci.id }),
                           let dersIndex = studentManager.ogrenciler[ogrenciIndex].dersler.firstIndex(where: { $0.id == ders.id }) {
                            studentManager.dersSil(ogrenciIndex: ogrenciIndex, dersIndex: dersIndex)
                        }
                    } label: {
                        Label("Dersi Sil", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: Theme.FontSize.body))
                        .foregroundColor(Theme.appColor)
                }
            }
            
            Text(ders.ad)
                .font(.system(size: Theme.FontSize.body))
                .foregroundColor(.primary.opacity(0.8))
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    NotBilgisiView(label: "Vize", value: ders.vizeNotu)
                    NotBilgisiView(label: "Final", value: ders.finalNotu)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Ortalama: \(String(format: "%.1f", ders.ortalama))")
                        .font(.system(size: Theme.FontSize.caption))
                        .foregroundColor(.primary.opacity(0.8))
                    Text(ders.harfNotu)
                        .font(.system(size: Theme.FontSize.headline, weight: .bold))
                        .foregroundColor(Theme.harfNotuRengi(ders.harfNotu))
                }
            }
            
            HStack {
                Text("Kredi: \(ders.kredi)")
                Spacer()
                Text("AKTS: \(ders.akts)")
                Spacer()
                Text("Ağırlıklı: \(String(format: "%.2f", ders.agirlikliNot))")
            }
            .font(.system(size: Theme.FontSize.caption))
            .foregroundColor(.primary.opacity(0.8))
        }
        .padding(Theme.CardStyle.padding)
        .background(
            RoundedRectangle(cornerRadius: Theme.CardStyle.cornerRadius)
                .fill(Theme.cardBackground)
                .shadow(color: Theme.cardShadow, radius: Theme.CardStyle.shadowRadius)
        )
        .onTapGesture {
            showingDuzenleView = true
        }
        .sheet(isPresented: $showingDuzenleView) {
            if let ogrenciIndex = studentManager.ogrenciler.firstIndex(where: { $0.id == ogrenci.id }),
               let dersIndex = studentManager.ogrenciler[ogrenciIndex].dersler.firstIndex(where: { $0.id == ders.id }) {
                DersDuzenleView(ogrenciIndex: ogrenciIndex, dersIndex: dersIndex, ders: ders)
            }
        }
    }
}

struct NotBilgisiView: View {
    let label: String
    let value: Double?
    
    var body: some View {
        HStack(spacing: 4) {
            Text("\(label):")
                .font(.system(size: Theme.FontSize.caption))
                .foregroundColor(.primary.opacity(0.8))
            Text(value?.description ?? "-")
                .font(.system(size: Theme.FontSize.caption, weight: .medium))
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    let testOgrenci = Ogrenci(id: UUID(), adSoyad: "Test Öğrenci", ogrenciNo: "123456", dersler: [])
    let testDers = Ders(id: UUID(), kod: "TEST101", ad: "Test Dersi", kredi: 3, akts: 5, donem: 1, vizeNotu: 90, finalNotu: 85)
    return DersKartiView(ogrenci: testOgrenci, ders: testDers)
        .environmentObject(StudentManager())
        .padding()
} 