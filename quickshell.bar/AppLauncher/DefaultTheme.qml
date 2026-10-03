import QtQuick

QtObject {
    readonly property color bgBase: "#0f1417"
    readonly property color bgSurface: "#1b2023"
    readonly property color bgOverlay: "#000000"
    readonly property color bgHover: "#262b2e"
    readonly property color bgSelected: "#364954"
    readonly property color bgBorder: "#40484d"

    readonly property color textPrimary: "#dfe3e7"
    readonly property color textSecondary: "#c0c7cd"
    readonly property color textMuted: "#8a9297"

    readonly property color accentPrimary: "#8ecff2"
    readonly property color accentCyan: "#b5c9d7"
    readonly property color accentGreen: "#c9c2ea"
    readonly property color accentOrange: "#474364"
    readonly property color accentRed: "#ffb4ab"

    readonly property color urgencyLow: textMuted
    readonly property color urgencyNormal: accentPrimary
    readonly property color urgencyCritical: accentRed
    readonly property color batteryGood: accentGreen
    readonly property color batteryWarning: accentOrange
    readonly property color batteryCritical: accentRed
}
