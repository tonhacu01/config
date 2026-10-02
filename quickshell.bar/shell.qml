import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.modules
import qs.AppLauncher
import qs.Wallpaper

PanelWindow {
    id: bar

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: -5
        left: 0   
        right: 0  
    }

    implicitHeight: 70
    implicitWidth: 1000
    color: "transparent"

    exclusiveZone: 45

    // ─────────────────────────────────────────────
    // MATUGEN COLORS
    // ─────────────────────────────────────────────
/*
    FileView {
        id: colorsFile

        path: Quickshell.env("HOME") + "/.config/quickshell/colors.json"

        watchChanges: true
        onFileChanged: reload()
    }

    readonly property var colors: {
        if (!colorsFile.loaded || colorsFile.text() === "")
            return {
                bg0: "#040e0d",
                bg1: "#0a1816",
                bg2: "#0f211f",
                bg3: "#152a26",
                bg4: "#1d3631",

                fg: "#f5e2c5",

                red: "#ff6048",
                orange: "#ffa478",
                yellow: "#f5cd5b",
                green: "#7ad9a8",
                aqua: "#3dd1b0",
                blue: "#5fc8d4",
                purple: "#e89aa8",

                grey0: "#3a1a35",
                grey1: "#5a4d3e",
                grey2: "#c4b09a"
            }

        return JSON.parse(colorsFile.text())
    }

*/

    // ─────────────────────────────────────────────
    // LEFT - CURRENT WINDOW
    // ─────────────────────────────────────────────

    Pill {
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter

        icon: "pause"
        iconColor: Colors.aqua
        maxLabelWidth: 220

        // Chỉ đổi FILL = 1 cho Pill này
        iconAxes: {
            "FILL": 1,
            "wght": 400,
            "GRAD": 0,
            "opsz": 24
        }

        label: winPoller.value !== "" ? winPoller.value : "Desktop"
    }


    // ─────────────────────────────────────────────
    // CENTER - CLOCK + WORKSPACES
    // ─────────────────────────────────────────────

    RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        spacing: 8

        Pill {
            icon: "nest_clock_farsight_analog"

            iconColor: Colors.orange

            label: clock.value
        }

        Workspace {
        }
    }


    // ─────────────────────────────────────────────
    // RIGHT
    // ─────────────────────────────────────────────

    RowLayout {
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter

        spacing: 8


        // Battery
        Pill {
            icon: "battery_android_full"

            iconColor: Colors.green

            label: "100%"
        }


        // Bluetooth
        Pill {
            icon: "bluetooth"

            iconColor: Colors.yellow

            label: "On"
        }


        // Wi-Fi
        Pill {
            icon: "network_wifi"

            iconColor: Colors.purple

            label: "Aero 5G"
        }


        // Volume
        Pill {
            icon: "volume_up"

            iconColor: Colors.green

            label: vol.value + "%"
        }
    }


    // ─────────────────────────────────────────────
    // POLLERS
    // ─────────────────────────────────────────────

    // Active Window Title Poller
    Poller {
        id: winPoller

        command: "hyprctl activewindow -j | jq -r 'if .title != \"\" then .title else (.class // \"Desktop\") end'"

        interval: 300
    }

    // Clock Poller
    Poller {
        id: clock

        command: "date +%H:%M"

        interval: 60000
    }

    // Volume Poller
    Poller {
        id: vol

        command: "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'"

        interval: 1000
    }

    AppLauncher {}

    WallpaperManager { theme: ts.theme }

}