import SwiftUI
import Magi

@main
struct MagiShowcaseApp: App {
    var body: some Scene {
        WindowGroup {
            ComponentShowcase()
        }
        .windowStyle(.titleBar)
        .defaultSize(width: 900, height: 700)
    }
}
