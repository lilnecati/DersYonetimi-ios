import Foundation

class StudentManager: ObservableObject {
    @Published var ogrenciler: [Ogrenci] = [] {
        didSet {
            verileriKaydet()
        }
    }
    
    private var dosyaURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("ogrenciler.json")
    }
    
    init() {
        verileriYukle()
    }
    
    private func verileriKaydet() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(ogrenciler)
            try data.write(to: dosyaURL)
            print("Veriler kaydedildi: \(dosyaURL.path)")
        } catch {
            print("Veri kaydetme hatası: \(error.localizedDescription)")
        }
    }
    
    private func verileriYukle() {
        do {
            let data = try Data(contentsOf: dosyaURL)
            ogrenciler = try JSONDecoder().decode([Ogrenci].self, from: data)
            print("Veriler yüklendi")
        } catch {
            print("Veri yükleme hatası (ilk çalıştırma olabilir): \(error.localizedDescription)")
            ogrenciler = []
        }
    }
    
    func ogrenciEkle(adSoyad: String, ogrenciNo: String) {
        let yeniOgrenci = Ogrenci(id: UUID(), adSoyad: adSoyad, ogrenciNo: ogrenciNo, dersler: [])
        ogrenciler.append(yeniOgrenci)
    }
    
    func ogrenciSil(at index: Int) {
        ogrenciler.remove(at: index)
    }
    
    func dersEkle(ogrenciIndex: Int, kod: String, ad: String, kredi: Int, akts: Int, donem: Int) {
        let yeniDers = Ders(id: UUID(), kod: kod, ad: ad, kredi: kredi, akts: akts, donem: donem, vizeNotu: nil, finalNotu: nil)
        ogrenciler[ogrenciIndex].dersler.append(yeniDers)
        objectWillChange.send()
        verileriKaydet()
    }
    
    func dersSil(ogrenciIndex: Int, dersIndex: Int) {
        ogrenciler[ogrenciIndex].dersler.remove(at: dersIndex)
        objectWillChange.send()
        verileriKaydet()
    }
    
    func notGuncelle(ogrenciIndex: Int, dersIndex: Int, vizeNotu: Double?, finalNotu: Double?) {
        ogrenciler[ogrenciIndex].dersler[dersIndex].vizeNotu = vizeNotu
        ogrenciler[ogrenciIndex].dersler[dersIndex].finalNotu = finalNotu
        objectWillChange.send()
        verileriKaydet()
    }
} 