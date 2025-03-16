import Foundation

struct Ogrenci: Identifiable, Codable {
    var id: UUID
    var adSoyad: String
    var ogrenciNo: String
    var dersler: [Ders]
    
    var donem1Dersleri: [Ders] {
        dersler.filter { $0.donem == 1 }
    }
    
    var donem2Dersleri: [Ders] {
        dersler.filter { $0.donem == 2 }
    }
    
    // 5. Toplam Ağırlıklı Not / Toplam AKTS = GANO
    var genelOrtalama: Double {
        let gecerliDersler = dersler.filter { $0.harfNotu != "FF" && $0.harfNotu != "-" }
        guard !gecerliDersler.isEmpty else { return 0.0 }
        
        let toplamAkts = gecerliDersler.reduce(0) { $0 + $1.akts }
        let toplamAgirlikliNot = gecerliDersler.reduce(0.0) { $0 + $1.agirlikliNot }
        
        return (toplamAgirlikliNot / Double(toplamAkts)).rounded(to: 2)
    }
    
    func donemOrtalamasi(_ donem: Int) -> Double {
        let donemDersleri = dersler.filter { $0.donem == donem && $0.harfNotu != "FF" && $0.harfNotu != "-" }
        guard !donemDersleri.isEmpty else { return 0.0 }
        
        let toplamAkts = donemDersleri.reduce(0) { $0 + $1.akts }
        let toplamAgirlikliNot = donemDersleri.reduce(0.0) { $0 + $1.agirlikliNot }
        
        return (toplamAgirlikliNot / Double(toplamAkts)).rounded(to: 2)
    }
    
    // Yardımcı fonksiyonlar
    var toplamAkts: Int {
        dersler.reduce(0) { $0 + $1.akts }
    }
    
    var donem1Akts: Int {
        donem1Dersleri.reduce(0) { $0 + $1.akts }
    }
    
    var donem2Akts: Int {
        donem2Dersleri.reduce(0) { $0 + $1.akts }
    }
}

extension Double {
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
} 