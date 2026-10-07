import QtQuick

QtObject {
    readonly property color bgBase: "#0e1513"
    readonly property color bgSurface: "#1b211f"
    readonly property color bgOverlay: "#000000"
    readonly property color bgHover: "#252b29"
    readonly property color bgSelected: "#334b45"
    readonly property color bgBorder: "#3f4946"

    readonly property color textPrimary: "#dee4e0"
    readonly property color textSecondary: "#bfc9c4"
    readonly property color textMuted: "#89938f"

    readonly property color accentPrimary: "#84d6c2"
    readonly property color accentCyan: "#b1ccc4"
    readonly property color accentGreen: "#aacbe4"
    readonly property color accentOrange: "#2a4a5f"
    readonly property color accentRed: "#ffb4ab"

    readonly property color urgencyLow: textMuted
    readonly property color urgencyNormal: accentPrimary
    readonly property color urgencyCritical: accentRed
    readonly property color batteryGood: accentGreen
    readonly property color batteryWarning: accentOrange
    readonly property color batteryCritical: accentRed
}
