import SwiftUI

struct ContentView: View {
    @StateObject private var studentManager = StudentManager()
    
    var body: some View {
        NavigationView {
            OgrenciListesiView()
        }
        .environmentObject(studentManager)
    }
}

#Preview {
    ContentView()
} 