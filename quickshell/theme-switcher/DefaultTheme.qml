import QtQuick

QtObject {
    readonly property color bgBase: "{{ colors.background.default.hex }}"
    readonly property color bgSurface: "{{ colors.surface.default.hex }}"
    readonly property color bgOverlay: "{{ colors.scrim.default.hex }}"
    readonly property color bgHover: "{{ colors.surface_container_low.default.hex }}"
    readonly property color bgSelected: "{{ colors.primary_container.default.hex }}"
    readonly property color bgBorder: "{{ colors.outline_variant.default.hex }}"

    readonly property color textPrimary: "{{ colors.on_surface.default.hex }}"
    readonly property color textSecondary: "{{ colors.on_surface_variant.default.hex }}"
    readonly property color textMuted: "{{ colors.outline.default.hex }}"

    readonly property color accentPrimary: "{{ colors.primary.default.hex }}"
    readonly property color accentCyan: "{{ colors.secondary.default.hex }}"
    readonly property color accentGreen: "{{ colors.tertiary.default.hex }}"
    readonly property color accentOrange: "{{ colors.secondary_container.default.hex }}"
    readonly property color accentRed: "{{ colors.error.default.hex }}"

    readonly property color urgencyLow: textMuted
    readonly property color urgencyNormal: accentPrimary
    readonly property color urgencyCritical: accentRed

    readonly property color batteryGood: accentGreen
    readonly property color batteryWarning: accentOrange
    readonly property color batteryCritical: accentRed
}