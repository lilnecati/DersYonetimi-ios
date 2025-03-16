import SwiftUI

struct Theme {
    static let appColor = Color("AppThemeColor")
    
    static let cardBackground = Color(.systemBackground)
    static let cardShadow = Color(.label).opacity(0.1)
    
    static let harfNotuRenkleri: [String: Color] = [
        "AA": Color(hex: "2E7D32"),  // Koyu yeşil
        "BA": Color(hex: "388E3C"),  // Yeşil
        "BB": Color(hex: "43A047"),  // Açık yeşil
        "CB": Color(hex: "7CB342"),  // Sarımsı yeşil
        "CC": Color(hex: "C0CA33"),  // Lime
        "DC": Color(hex: "FDD835"),  // Sarı
        "DD": Color(hex: "FFB300"),  // Amber
        "FD": Color(hex: "FB8C00"),  // Turuncu
        "FF": Color(hex: "E53935")   // Kırmızı
    ]
    
    static func harfNotuRengi(_ harfNotu: String) -> Color {
        harfNotuRenkleri[harfNotu] ?? .secondary
    }
    
    struct CardStyle {
        static let cornerRadius: CGFloat = 12
        static let shadowRadius: CGFloat = 5
        static let padding: CGFloat = 16
        static let spacing: CGFloat = 12
    }
    
    struct FontSize {
        static let title: CGFloat = 24
        static let headline: CGFloat = 17
        static let body: CGFloat = 15
        static let caption: CGFloat = 12
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
} 