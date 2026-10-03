import QtQuick
import "../theme-switcher" as ThemeSwitcher

QtObject {
    readonly property color bgBase: ThemeSwitcher.Theme.bgBase
    readonly property color bgSurface: ThemeSwitcher.Theme.bgSurface
    readonly property color bgHover: ThemeSwitcher.Theme.bgHover
    readonly property color bgSelected: ThemeSwitcher.Theme.bgSelected
    readonly property color bgBorder: ThemeSwitcher.Theme.bgBorder

    readonly property color textPrimary: ThemeSwitcher.Theme.textPrimary
    readonly property color textSecondary: ThemeSwitcher.Theme.textSecondary
    readonly property color textMuted: ThemeSwitcher.Theme.textMuted

    readonly property color accentPrimary: ThemeSwitcher.Theme.accentPrimary
    readonly property color accentCyan: ThemeSwitcher.Theme.accentCyan
    readonly property color accentGreen: ThemeSwitcher.Theme.accentGreen
    readonly property color accentOrange: ThemeSwitcher.Theme.accentOrange
    readonly property color accentRed: ThemeSwitcher.Theme.accentRed
}