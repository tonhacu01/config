pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property color bg0: "#040e0d"
    property color bg1: "#0a1816"
    property color bg2: "#0f211f"
    property color bg3: "#152a26"
    property color bg4: "#1d3631"

    property color fg: "#f5e2c5"

    property color red: "#ff6048"
    property color orange: "#ffa478"
    property color yellow: "#f5cd5b"
    property color green: "#7ad9a8"
    property color aqua: "#3dd1b0"
    property color blue: "#5fc8d4"
    property color purple: "#e89aa8"

    property color grey0: "#3a1a35"
    property color grey1: "#5a4d3e"
    property color grey2: "#c4b09a"

    FileView {
        id: colorsFile

        path: Quickshell.env("HOME") + "/.config/quickshell/colors.json"
        watchChanges: true

        onFileChanged: reload()

        JsonAdapter {
            property color bg0: root.bg0
            property color bg1: root.bg1
            property color bg2: root.bg2
            property color bg3: root.bg3
            property color bg4: root.bg4

            property color fg: root.fg

            property color red: root.red
            property color orange: root.orange
            property color yellow: root.yellow
            property color green: root.green
            property color aqua: root.aqua
            property color blue: root.blue
            property color purple: root.purple

            property color grey0: root.grey0
            property color grey1: root.grey1
            property color grey2: root.grey2
        }
    }
}