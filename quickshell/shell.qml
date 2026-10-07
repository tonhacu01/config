import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes
import QtQuick.Shapes.DesignHelpers

import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower

import qs.modules
import qs.modules.ArchPill
import qs.modules.ControlPill
import qs.AppLauncher
import qs.Wallpaper
import qs.ScreenCorners
import qs.osd
import "./theme-switcher"

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
    color: "transparent"

    // Reserve only 45px despite the visual window being 70px.
    exclusiveZone: 45


    // =========================================================
    // MATUGEN COLORS
    // =========================================================

    FileView {
        id: colorsFile

        path: Quickshell.env("HOME")
              + "/.config/quickshell/colors.json"

        watchChanges: true
        onFileChanged: reload()
    }

    readonly property var colors: {
        if (!colorsFile.loaded || colorsFile.text() === "") {
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
        }

        return JSON.parse(colorsFile.text())
    }


    // =========================================================
    // THEME
    // =========================================================

    ThemeSwitcher {
        id: ts
    }


    // =========================================================
    // LEFT
    // =========================================================

    Pill {
        anchors {
            left: parent.left
            leftMargin: 68
            verticalCenter: parent.verticalCenter
        }

        icon: "pause"
        
        iconColor: Colors.aqua
        maxLabelWidth: 220

        iconAxes: ({
            FILL: 1,
            wght: 400,
            GRAD: 0,
            opsz: 24
        })

        label: winPoller.value !== ""
            ? winPoller.value
            : "Desktop"
    }


    // =========================================================
    // CENTER
    // =========================================================

    RowLayout {
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        spacing: 8

        Pill {
            icon: "nest_clock_farsight_analog"
            iconColor: Colors.orange
            label: clock.value
        }

        Workspace {}
    }


    // =========================================================
    // RIGHT
    // =========================================================

    RowLayout {
        anchors {
            right: parent.right
            rightMargin: 20
            verticalCenter: parent.verticalCenter
        }

        spacing: 8

        Pill {
            icon: "volume_up"
            iconColor: Colors.aqua
            label: vol.value + "%"
        }

        Pill {
            icon: "network_wifi"
            iconColor: "#ffb8e2"
            label: "Aero 5G"
        }

        Pill {
            icon: "battery_android_full"
            iconColor: Colors.green
            label: "100%"
        }

        // -----------------------------------------------------
        // CONTROL PILL
        // -----------------------------------------------------

        Item {
            id: controlPillContainer

            implicitWidth: controlPill.implicitWidth
            implicitHeight: controlPill.implicitHeight

            width: controlPill.width
            height: controlPill.height

            ControlPill {
                id: controlPill

                anchors.fill: parent

                theme: ts.theme
            }

            // Transparent click layer
            MouseArea {
                id: controlPillMouseArea

                anchors.fill: parent

                z: 100

                acceptedButtons: Qt.LeftButton

                onClicked: {
                    Quickshell.execDetached([
                        "qs",
                        "ipc",
                        "call",
                        "controlcenter",
                        "toggle"
                    ])
                }
            }
        }
    }


    // =========================================================
    // POLLERS
    // =========================================================

    Poller {
        id: winPoller

        command: "hyprctl activewindow -j | jq -r 'if .title != \"\" then .title else (.class // \"Desktop\") end'"

        interval: 300
    }

    Poller {
        id: clock

        command: "date +%H:%M"

        interval: 60000
    }

    Poller {
        id: vol

        command: "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'"

        interval: 1000
    }


    // =========================================================
    // GLOBAL MODULES
    // =========================================================

    AppLauncher {}

    WallpaperManager {
        theme: ts.theme
    }

    Control {}

    Notifications {}


    // =========================================================
    // IPC
    // =========================================================

    IpcHandler {
        target: "lockscreen"

        function lock(): void {
            lockScreen.lock()
        }

        function unlock(): void {
            lockScreen.unlock()
        }

        function toggle(): void {
            lockScreen.toggle()
        }
    }


    // =========================================================
    // LOCKSCREEN
    // =========================================================

    LockScreen {
        id: lockScreen
    }


    // =========================================================
    // SCREEN CORNERS
    // =========================================================

    ScreenCorners {}


    // =========================================================
    // ARCH PILL
    // =========================================================

    Item {
        id: archPillContainer

        anchors {
            left: parent.left
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }

        implicitWidth: archPill.implicitWidth
        implicitHeight: archPill.implicitHeight

        width: archPill.width
        height: archPill.height

        ArchPill {
            id: archPill

            anchors.fill: parent

            theme: ts.theme
        }

        // Transparent click layer
        MouseArea {
            id: archPillMouseArea

            anchors.fill: parent

            z: 100

            acceptedButtons: Qt.LeftButton

            onClicked: {
                Quickshell.execDetached([
                    "qs",
                    "ipc",
                    "call",
                    "launcher",
                    "toggle"
                ])
            }
        }

        OSD { theme: ts.theme }
    }
}