import QtQuick

QtObject {
    readonly property color bgBase: "#0e1513"
    readonly property color bgSurface: "#232927"
    readonly property color bgOverlay: "#000000"
    readonly property color bgHover: "#2d3432"
    readonly property color bgSelected: "#7c968e"
    readonly property color bgBorder: "#88938f"

    readonly property color textPrimary: "#ffffff"
    readonly property color textSecondary: "#d4dfda"
    readonly property color textMuted: "#aab4b0"

    readonly property color accentPrimary: "#9aecd8"
    readonly property color accentCyan: "#c7e2d9"
    readonly property color accentGreen: "#c0e0fa"
    readonly property color accentOrange: "#7595ac"
    readonly property color accentRed: "#ffd2cc"

    readonly property color urgencyLow: textMuted
    readonly property color urgencyNormal: accentPrimary
    readonly property color urgencyCritical: accentRed
    readonly property color batteryGood: accentGreen
    readonly property color batteryWarning: accentOrange
    readonly property color batteryCritical: accentRed
}
