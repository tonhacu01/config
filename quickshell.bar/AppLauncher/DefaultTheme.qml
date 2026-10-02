import QtQuick

QtObject {
    // ─────────────────────────────────────
    // Ariadne
    // ─────────────────────────────────────

    readonly property color bgBase: "#040e0d"
    readonly property color bgSurface: "#0a1816"
    readonly property color bgOverlay: "#88000000"
    readonly property color bgHover: "#0f211f"
    readonly property color bgSelected: "#152a26"
    readonly property color bgBorder: "#1d3631"

    readonly property color textPrimary: "#f5e2c5"
    readonly property color textSecondary: "#c9bfa9"
    readonly property color textMuted: "#817d72"

    readonly property color accentPrimary: "#3dd1b0"
    readonly property color accentCyan: "#5fc8d4"
    readonly property color accentGreen: "#7ad9a8"
    readonly property color accentOrange: "#ffa478"
    readonly property color accentRed: "#ff6048"

    // ─────────────────────────────────────
    // Semantic colors
    // ─────────────────────────────────────

    readonly property color urgencyLow: textMuted
    readonly property color urgencyNormal: accentPrimary
    readonly property color urgencyCritical: accentRed

    readonly property color batteryGood: accentGreen
    readonly property color batteryWarning: accentOrange
    readonly property color batteryCritical: accentRed
}
