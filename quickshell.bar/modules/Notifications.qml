import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.Pipewire

import qs

PanelWindow {
    id: root

    // ================================================================
    // IPC COMMUNICATION & STATE
    // ================================================================

    IpcHandler {
        target: "notifications"

        function toggle() {
            root.visible = !root.visible
        }

        function open() {
            root.visible = true
        }

        function close() {
            root.visible = false
        }
    }

    visible: false

    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "notifications"

    anchors {
        top: true
        bottom: true
        right: true
    }

    margins {
        top: 0
        bottom: 0
        right: 0
    }

    width: 390
    color: "transparent"

    // ================================================================
    // BRIGHTNESS
    // ================================================================

    property real brightnessValue: 0.75

    Process {
        id: brightnessGet

        command: [
            "sh",
            "-c",
            "brightnessctl -m | awk -F, '{gsub(/%/,\"\",$4); print $4}'"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                var value = parseFloat(this.text.trim())

                if (!isNaN(value)) {
                    root.brightnessValue =
                        Math.max(0, Math.min(1, value / 100))
                }
            }
        }
    }

    Process {
        id: brightnessSet
    }

    function setBrightness(value) {
        root.brightnessValue = value

        var percent = Math.round(value * 100)

        brightnessSet.command = [
            "brightnessctl",
            "set",
            percent + "%"
        ]

        brightnessSet.running = true
    }

    // ================================================================
    // PIPEWIRE
    // ================================================================

    // Quan trọng:
    // PwNodeAudio.volume cần node được bind.
    PwObjectTracker {
        id: audioTracker

        objects: [
            Pipewire.defaultAudioSink
        ]
    }

    // ================================================================
    // MAIN CONTENT
    // ================================================================

    Item {
        anchors.fill: parent
        anchors.margins: 12

        Rectangle {
            id: mainContent

            anchors.fill: parent

            radius: 20

            color: Colors.bg0

            border.color: Colors.bg1
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16

                spacing: 14

                // ====================================================
                // QUICK SETTINGS
                // ====================================================

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220

                    radius: 14
                    color: Colors.bg1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 14

                        spacing: 12

                        // ====================================================
                        // BRIGHTNESS
                        // ====================================================

                        RowLayout {
                            Layout.fillWidth: true

                            spacing: 12

                            Text {
                                text: "settings"

                                color: Colors.grey1

                                font.pixelSize: 18
                                font.family: "Material Symbols Outlined"

                                Layout.preferredWidth: 20

                                horizontalAlignment:
                                    Text.AlignHCenter
                            }

                            Slider {
                                id: brightnessSlider

                                Layout.fillWidth: true

                                // Quan trọng: slider có đúng chiều cao
                                Layout.preferredHeight: 26

                                from: 0
                                to: 1

                                value: root.brightnessValue

                                live: true

                                onMoved: {
                                    root.setBrightness(value)
                                }

                                // ------------------------------------------------
                                // TRACK
                                // ------------------------------------------------

                                background: Rectangle {
                                    x: brightnessSlider.leftPadding

                                    y: brightnessSlider.topPadding +
                                       brightnessSlider.availableHeight / 2 -
                                       height / 2

                                    width: brightnessSlider.availableWidth

                                    height: 10

                                    radius: 5

                                    color: Colors.bg2

                                    // Active part
                                    Rectangle {
                                        width:
                                            brightnessSlider.visualPosition *
                                            parent.width

                                        height: parent.height

                                        radius: 5

                                        color: Colors.aqua
                                    }
                                }

                                // ------------------------------------------------
                                // HANDLE
                                // ------------------------------------------------

                                handle: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16

                                    width: 16
                                    height: 16

                                    x: brightnessSlider.leftPadding +
                                       brightnessSlider.visualPosition *
                                       (
                                           brightnessSlider.availableWidth -
                                           width
                                       )

                                    y: brightnessSlider.topPadding +
                                       brightnessSlider.availableHeight / 2 -
                                       height / 2

                                    radius: width / 2

                                    color: Colors.fg
                                }
                            }
                        }

                        // ====================================================
                        // DISPLAY PLACEHOLDER
                        // ====================================================

                        RowLayout {
                            Layout.fillWidth: true

                            spacing: 12

                            Text {
                                text: "desktop_windows"

                                color: Colors.grey1

                                font.pixelSize: 18
                                font.family: "Material Symbols Outlined"

                                Layout.preferredWidth: 20

                                horizontalAlignment:
                                    Text.AlignHCenter
                            }

                            Slider {
                                id: displaySlider

                                Layout.fillWidth: true
                                Layout.preferredHeight: 26

                                from: 0
                                to: 1

                                value: 0.60

                                enabled: false

                                opacity: 0.65

                                background: Rectangle {
                                    x: displaySlider.leftPadding

                                    y: displaySlider.topPadding +
                                       displaySlider.availableHeight / 2 -
                                       height / 2

                                    width: displaySlider.availableWidth

                                    height: 10

                                    radius: 5

                                    color: Colors.bg2

                                    Rectangle {
                                        width:
                                            displaySlider.visualPosition *
                                            parent.width

                                        height: parent.height

                                        radius: 5

                                        color: Colors.aqua
                                    }
                                }

                                handle: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16

                                    width: 16
                                    height: 16

                                    x: displaySlider.leftPadding +
                                       displaySlider.visualPosition *
                                       (
                                           displaySlider.availableWidth -
                                           width
                                       )

                                    y: displaySlider.topPadding +
                                       displaySlider.availableHeight / 2 -
                                       height / 2

                                    radius: width / 2

                                    color: Colors.grey1
                                }
                            }
                        }

                        // ====================================================
                        // VOLUME
                        // ====================================================

                        RowLayout {
                            Layout.fillWidth: true

                            spacing: 12

                            Text {
                                text: "volume_up"

                                color: Colors.grey1

                                font.pixelSize: 18
                                font.family: "Material Symbols Outlined"

                                Layout.preferredWidth: 20

                                horizontalAlignment:
                                    Text.AlignHCenter
                            }

                            Slider {
                                id: volumeSlider

                                Layout.fillWidth: true
                                Layout.preferredHeight: 26

                                from: 0
                                to: 1

                                live: true

                                // Đọc volume thật
                                value:
                                    Pipewire.defaultAudioSink &&
                                    Pipewire.defaultAudioSink.audio
                                    ? Pipewire.defaultAudioSink.audio.volume
                                    : 0

                                onMoved: {
                                    var sink =
                                        Pipewire.defaultAudioSink

                                    if (
                                        sink &&
                                        sink.audio &&
                                        sink.ready
                                    ) {
                                        sink.audio.volume = value
                                    }
                                }

                                // ------------------------------------------------
                                // TRACK
                                // ------------------------------------------------

                                background: Rectangle {
                                    x: volumeSlider.leftPadding

                                    y: volumeSlider.topPadding +
                                       volumeSlider.availableHeight / 2 -
                                       height / 2

                                    width: volumeSlider.availableWidth

                                    height: 10

                                    radius: 5

                                    color: Colors.bg2

                                    // Active volume
                                    Rectangle {
                                        width:
                                            volumeSlider.visualPosition *
                                            parent.width

                                        height: parent.height

                                        radius: 5

                                        color: Colors.aqua
                                    }
                                }

                                // ------------------------------------------------
                                // HANDLE
                                // ------------------------------------------------

                                handle: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16

                                    width: 16
                                    height: 16

                                    x: volumeSlider.leftPadding +
                                       volumeSlider.visualPosition *
                                       (
                                           volumeSlider.availableWidth -
                                           width
                                       )

                                    y: volumeSlider.topPadding +
                                       volumeSlider.availableHeight / 2 -
                                       height / 2

                                    radius: width / 2

                                    color: Colors.fg
                                }
                            }
                        }

                        Item {
                            Layout.preferredHeight: 2
                        }

                        // ====================================================
                        // WI-FI + BLUETOOTH
                        // ====================================================

                        RowLayout {
                            Layout.fillWidth: true

                            spacing: 10

                            // =================================================
                            // WI-FI
                            // =================================================

                            Rectangle {
                                Layout.fillWidth: true

                                height: 50

                                radius: 10

                                color: Colors.bg2

                                RowLayout {
                                    anchors.fill: parent

                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10

                                    spacing: 10

                                    Rectangle {
                                        width: 32
                                        height: 32

                                        radius: 16

                                        color: Colors.aqua

                                        Text {
                                            anchors.centerIn: parent

                                            text: "wifi"

                                            color: Colors.bg0

                                            font.pixelSize: 18
                                            font.family:
                                                "Material Symbols Outlined"
                                        }
                                    }

                                    ColumnLayout {
                                        spacing: 1

                                        Layout.fillWidth: true

                                        Text {
                                            text: "Wi-Fi"

                                            color: Colors.fg

                                            font.pixelSize: 12
                                            font.bold: true

                                            font.family:
                                                "SF Pro Display"
                                        }

                                        Text {
                                            text: "Aero 5G"

                                            color: Colors.grey1

                                            font.pixelSize: 11

                                            font.family:
                                                "SF Pro Display"
                                        }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent

                                    cursorShape:
                                        Qt.PointingHandCursor
                                }
                            }

                            // =================================================
                            // BLUETOOTH
                            // =================================================

                            Rectangle {
                                Layout.fillWidth: true

                                height: 50

                                radius: 10

                                color: Colors.bg2

                                RowLayout {
                                    anchors.fill: parent

                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10

                                    spacing: 10

                                    Rectangle {
                                        width: 32
                                        height: 32

                                        radius: 16

                                        color: Colors.aqua

                                        Text {
                                            anchors.centerIn: parent

                                            text: "bluetooth"

                                            color: Colors.bg0

                                            font.pixelSize: 18
                                            font.family:
                                                "Material Symbols Outlined"
                                        }
                                    }

                                    ColumnLayout {
                                        spacing: 1

                                        Layout.fillWidth: true

                                        Text {
                                            text: "Bluetooth"

                                            color: Colors.fg

                                            font.pixelSize: 12
                                            font.bold: true

                                            font.family:
                                                "SF Pro Display"
                                        }

                                        Text {
                                            text: "On"

                                            color: Colors.grey1

                                            font.pixelSize: 11

                                            font.family:
                                                "SF Pro Display"
                                        }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent

                                    cursorShape:
                                        Qt.PointingHandCursor
                                }
                            }
                        }
                    }
                }

                // ====================================================
                // NOTIFICATIONS
                // ====================================================

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    radius: 14

                    color: Colors.bg1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 14

                        spacing: 12

                        Text {
                            text: "Notifications"

                            color: Colors.fg

                            font.pixelSize: 14
                            font.bold: true
                            font.family: "SF Pro Display"
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            Text {
                                anchors.centerIn: parent

                                text: "No notifications"

                                color: Colors.grey0

                                font.pixelSize: 13
                                font.family: "SF Pro Display"
                            }
                        }
                    }
                }
            }
        }
    }

    // ================================================================
    // INITIAL BRIGHTNESS
    // ================================================================

    Component.onCompleted: {
        brightnessGet.running = true
    }
}
