pragma Singleton

import QtQuick
import Quickshell
import "./theme-switcher"
Singleton {
    id: root

    property color bg0: Theme.bgBase
    property color bg1: Theme.bgSurface
    property color bg2: Theme.bgHover
    property color bg3: Theme.bgSelected
    property color bg4: Theme.bgBorder

    property color fg: Theme.textPrimary

    property color red: Theme.accentRed
    property color orange: Theme.accentOrange
    property color yellow: Theme.accentOrange
    property color green: Theme.accentGreen
    property color aqua: Theme.accentPrimary
    property color blue: Theme.accentCyan
    property color purple: Theme.accentPrimary

    property color grey0: Theme.bgBorder
    property color grey1: Theme.textMuted
    property color grey2: Theme.textSecondary
}