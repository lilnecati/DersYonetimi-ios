import SwiftUI

struct OgrenciListesiView: View {
    @EnvironmentObject var studentManager: StudentManager
    @State private var showingOgrenciEkle = false
    @State private var searchText = ""
    @State private var showingDeleteAlert = false
    @State private var selectedOgrenci: Ogrenci?
    
    var body: some View {
        NavigationStack {
            OgrenciListesiContent(viewModel: OgrenciListesiViewModel(
                studentManager: studentManager,
                showingOgrenciEkle: $showingOgrenciEkle,
                searchText: $searchText,
                showingDeleteAlert: $showingDeleteAlert,
                selectedOgrenci: $selectedOgrenci
            ))
        }
    }
}

struct OgrenciListesiViewModel {
    let studentManager: StudentManager
    let showingOgrenciEkle: Binding<Bool>
    let searchText: Binding<String>
    let showingDeleteAlert: Binding<Bool>
    let selectedOgrenci: Binding<Ogrenci?>
    
    var ogrenciler: [Ogrenci] {
        if searchText.wrappedValue.isEmpty {
            return studentManager.ogrenciler
        }
        return studentManager.ogrenciler.filter { ogrenci in
            ogrenci.adSoyad.lowercased().contains(searchText.wrappedValue.lowercased()) ||
            ogrenci.ogrenciNo.contains(searchText.wrappedValue)
        }
    }
    
    func deleteOgrenci(_ ogrenci: Ogrenci) {
        if let index = studentManager.ogrenciler.firstIndex(where: { $0.id == ogrenci.id }) {
            studentManager.ogrenciSil(at: index)
        }
    }
}

private struct OgrenciListesiContent: View {
    @EnvironmentObject var studentManager: StudentManager
    let viewModel: OgrenciListesiViewModel
    
    var body: some View {
        listContent
            .listStyle(.plain)
            .navigationTitle("Öğrenciler")
            .searchable(text: viewModel.searchText, prompt: "İsim veya öğrenci no ile ara")
            .toolbar { toolbarContent }
            .sheet(isPresented: viewModel.showingOgrenciEkle) {
                OgrenciEkleView()
            }
            .alert("Öğrenciyi Sil",
                   isPresented: viewModel.showingDeleteAlert,
                   presenting: viewModel.selectedOgrenci.wrappedValue
            ) { ogrenci in
                alertButtons(for: ogrenci)
            } message: { ogrenci in
                Text("\(ogrenci.adSoyad) isimli öğrenciyi silmek istediğinize emin misiniz?")
            }
    }
    
    private var listContent: some View {
        List {
            if studentManager.ogrenciler.isEmpty {
                EmptyStateView()
            } else {
                ForEach(viewModel.ogrenciler) { ogrenci in
                    ogrenciCard(for: ogrenci)
                }
            }
        }
    }
    
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.showingOgrenciEkle.wrappedValue = true
            } label: {
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 16, weight: .semibold))
            }
        }
    }
    
    private func alertButtons(for ogrenci: Ogrenci) -> some View {
        Group {
            Button("İptal", role: .cancel) {}
            Button("Sil", role: .destructive) {
                viewModel.deleteOgrenci(ogrenci)
            }
        }
    }
    
    private func ogrenciCard(for ogrenci: Ogrenci) -> some View {
        NavigationLink(destination: OgrenciDetayView(ogrenci: ogrenci)) {
            OgrenciKartiView(ogrenci: ogrenci)
                .contextMenu {
                    Button(role: .destructive) {
                        viewModel.selectedOgrenci.wrappedValue = ogrenci
                        viewModel.showingDeleteAlert.wrappedValue = true
                    } label: {
                        Label("Öğrenciyi Sil", systemImage: "trash")
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
        }
    }
}

struct OgrenciKartiView: View {
    let ogrenci: Ogrenci
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(ogrenci.adSoyad)
                        .font(.system(size: Theme.FontSize.headline, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(ogrenci.ogrenciNo)
                        .font(.system(size: Theme.FontSize.body))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: Theme.FontSize.body, weight: .semibold))
                    .foregroundColor(Theme.appColor)
            }
            
            HStack(spacing: 16) {
                NotKartiView(baslik: "GANO", deger: ogrenci.genelOrtalama)
                NotKartiView(baslik: "1. Dönem", deger: ogrenci.donemOrtalamasi(1))
                NotKartiView(baslik: "2. Dönem", deger: ogrenci.donemOrtalamasi(2))
            }
        }
        .padding(Theme.CardStyle.padding)
        .background(
            RoundedRectangle(cornerRadius: Theme.CardStyle.cornerRadius)
                .fill(Theme.cardBackground)
                .shadow(color: Theme.cardShadow, radius: Theme.CardStyle.shadowRadius)
        )
    }
}

struct NotKartiView: View {
    let baslik: String
    let deger: Double
    
    var body: some View {
        VStack(spacing: 4) {
            Text(baslik)
                .font(.system(size: Theme.FontSize.caption))
                .foregroundColor(.secondary)
            Text(String(format: "%.2f", deger))
                .font(.system(size: Theme.FontSize.body, weight: .semibold))
                .foregroundColor(Theme.appColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Theme.appColor.opacity(0.1))
        )
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.3")
                .font(.system(size: 50))
                .foregroundColor(Theme.appColor.opacity(0.5))
            
            Text("Henüz öğrenci bulunmuyor")
                .font(.system(size: Theme.FontSize.headline, weight: .medium))
                .foregroundColor(.primary)
            
            Text("Sağ üstteki + butonuna tıklayarak\nyeni öğrenci ekleyebilirsiniz")
                .font(.system(size: Theme.FontSize.body))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    OgrenciListesiView()
        .environmentObject(StudentManager())
} 