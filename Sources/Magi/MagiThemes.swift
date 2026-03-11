import SwiftUI

// MARK: - NERV — Command Center

public extension MagiTheme {
    static let nerv = MagiTheme(
        bgPrimary: Color(hex: 0x0A0A0A),
        bgSecondary: Color(hex: 0x141414),
        bgSurface: Color(hex: 0x1A1A1A),
        border: Color(hex: 0x2A2A2A),
        borderFocus: Color(hex: 0xCC0000),
        textPrimary: Color(hex: 0xE0E0E0),
        textMuted: Color(hex: 0x707070),
        accent: Color(hex: 0xCC0000),
        accentSecondary: Color(hex: 0x00AAAA),
        accentWarning: Color(hex: 0xCC8800),
        accentSuccess: Color(hex: 0x00AA66),
        danger: Color(hex: 0xFF3333),
        glowRadius: 8,
        scanLineOpacity: 0.08,
        style: MagiStyle(
            panelShape: .chamfer,
            chamferCut: 10
        )
    )
}
