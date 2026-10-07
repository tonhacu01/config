import QtQuick

QtObject {

    // ─────────────────────────────────────
    // Ariadne / Matugen
    // ─────────────────────────────────────

    readonly property color bgBase: "#0e1415"
    readonly property color bgSurface: "#1a2121"
    readonly property color bgOverlay: "#88000000"
    readonly property color bgHover: "#252b2b"
    readonly property color bgSelected: "#004f52"
    readonly property color bgBorder: "#3f4949"

    readonly property color textPrimary: "#dde4e3"
    readonly property color textSecondary: "#bec8c9"
    readonly property color textMuted: "#899393"

    readonly property color accentPrimary: "#80d4d8"
    readonly property color accentCyan: "#b1cccd"
    readonly property color accentGreen: "#b5c7e9"
    readonly property color accentOrange: "#324b4c"
    readonly property color accentRed: "#ffb4ab"

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
