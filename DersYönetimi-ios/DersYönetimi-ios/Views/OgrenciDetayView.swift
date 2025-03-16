import SwiftUI

struct OgrenciDetayView: View {
    @EnvironmentObject var studentManager: StudentManager
    let ogrenci: Ogrenci
    @State private var showingDersEkle = false
    @State private var selectedDonem = 1
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Öğrenci Bilgi Kartı
                VStack(spacing: 12) {
                    Text(ogrenci.adSoyad)
                        .font(.system(size: Theme.FontSize.title, weight: .bold))
                    Text(ogrenci.ogrenciNo)
                        .font(.system(size: Theme.FontSize.body))
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 16) {
                        OrtalamaKartiView(baslik: "GANO", deger: ogrenci.genelOrtalama)
                        OrtalamaKartiView(baslik: "1. Dönem", deger: ogrenci.donemOrtalamasi(1))
                        OrtalamaKartiView(baslik: "2. Dönem", deger: ogrenci.donemOrtalamasi(2))
                    }
                    .padding(.top, 8)
                }
                .padding(Theme.CardStyle.padding)
                .background(
                    RoundedRectangle(cornerRadius: Theme.CardStyle.cornerRadius)
                        .fill(Theme.appColor.opacity(0.1))
                        .shadow(color: Theme.cardShadow, radius: 3)
                )
                .padding(.horizontal)
                
                // Dönem Başlıkları ve Dersler
                ForEach([1, 2], id: \.self) { donem in
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("\(donem). Dönem")
                                .font(.system(size: Theme.FontSize.headline, weight: .bold))
                                .foregroundColor(Theme.appColor)
                            Spacer()
                            Button(action: {
                                selectedDonem = donem
                                showingDersEkle = true
                            }) {
                                Label("Ders Ekle", systemImage: "plus.circle.fill")
                                    .font(.system(size: Theme.FontSize.body, weight: .semibold))
                                    .foregroundColor(Theme.appColor)
                            }
                        }
                        .padding(.horizontal)
                        
                        let donemDersleri = donem == 1 ? ogrenci.donem1Dersleri : ogrenci.donem2Dersleri
                        
                        if donemDersleri.isEmpty {
                            EmptyDonemView()
                        } else {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ], spacing: 16) {
                                ForEach(donemDersleri) { ders in
                                    DersKartiView(ogrenci: ogrenci, ders: ders)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingDersEkle) {
            if let index = studentManager.ogrenciler.firstIndex(where: { $0.id == ogrenci.id }) {
                DersEkleView(ogrenciIndex: index, selectedDonem: selectedDonem)
            }
        }
    }
}

struct OrtalamaKartiView: View {
    let baslik: String
    let deger: Double
    
    var body: some View {
        VStack(spacing: 8) {
            Text(baslik)
                .font(.system(size: Theme.FontSize.caption))
                .foregroundColor(.secondary)
            Text(String(format: "%.2f", deger))
                .font(.system(size: Theme.FontSize.headline, weight: .bold))
                .foregroundColor(Theme.appColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: Theme.CardStyle.cornerRadius)
                .fill(Theme.cardBackground)
                .shadow(color: Theme.cardShadow, radius: 3)
        )
    }
}

struct EmptyDonemView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 12) {
                Image(systemName: "book.closed")
                    .font(.system(size: 40))
                    .foregroundColor(Theme.appColor.opacity(0.5))
                Text("Bu dönemde henüz ders bulunmuyor")
                    .font(.system(size: Theme.FontSize.body))
                    .foregroundColor(.secondary)
            }
            .padding(24)
            Spacer()
        }
    }
}

#Preview {
    NavigationView {
        OgrenciDetayView(ogrenci: Ogrenci(id: UUID(), adSoyad: "Test Öğrenci", ogrenciNo: "123456", dersler: []))
            .environmentObject(StudentManager())
    }
} 