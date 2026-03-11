import SwiftUI
import Magi

@main
struct MagiShowcaseApp: App {
    var body: some Scene {
        WindowGroup {
            ComponentShowcase()
                .onAppear {
                    NSApp.setActivationPolicy(.regular)
                    NSApp.activate(ignoringOtherApps: true)
                }
        }
        .windowStyle(.titleBar)
        .defaultSize(width: 900, height: 700)
    }
}
