import Foundation

struct Ders: Identifiable, Codable {
    var id: UUID
    var kod: String
    var ad: String
    var kredi: Int
    var akts: Int
    var donem: Int
    var vizeNotu: Double?
    var finalNotu: Double?
    
    var ortalama: Double {
        guard let vize = vizeNotu, let final = finalNotu else { return 0.0 }
        return (vize * 0.4 + final * 0.6).rounded(to: 2)
    }
    
    var harfNotu: String {
        let not = ortalama
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
    
    var agirlikliNot: Double {
        let harfKatsayilari: [String: Double] = [
            "AA": 4.0,
            "BA": 3.5,
            "BB": 3.0,
            "CB": 2.5,
            "CC": 2.0,
            "DC": 1.5,
            "DD": 1.0,
            "FD": 0.5,
            "FF": 0.0
        ]
        
        return Double(akts) * (harfKatsayilari[harfNotu] ?? 0.0)
    }
} 