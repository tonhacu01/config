pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property color bg0: jsonAdapter.bg0
    property color bg1: jsonAdapter.bg1
    property color bg2: jsonAdapter.bg2
    property color bg3: jsonAdapter.bg3
    property color bg4: jsonAdapter.bg4

    property color fg: jsonAdapter.fg

    property color red: jsonAdapter.red
    property color orange: jsonAdapter.orange
    property color yellow: jsonAdapter.yellow
    property color green: jsonAdapter.green
    property color aqua: jsonAdapter.aqua
    property color blue: jsonAdapter.blue
    property color purple: jsonAdapter.purple

    property color grey0: jsonAdapter.grey0
    property color grey1: jsonAdapter.grey1
    property color grey2: jsonAdapter.grey2

    FileView {
        id: colorsFile

        path: Quickshell.env("HOME") + "/.config/quickshell/colors.json"
        watchChanges: true

        // Khi file thay đổi (do Matugen ghi đè), yêu cầu reload lại nội dung
        onFileChanged: reload()
        Component.onCompleted: reload()

        JsonAdapter {
            id: jsonAdapter

            // Giá trị fallback nếu file json chưa kịp nạp
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
        }
    }
}
