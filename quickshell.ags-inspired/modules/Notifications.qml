import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
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

    // Đặt layer Overlay & Ignore Exclusion Zone để tràn toàn bộ chiều cao
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "notifications"

    // Neo sang bên PHẢI màn hình
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

    Item {
        anchors.fill: parent
        anchors.margins: 12

        // ============================================================
        // MAIN CONTENT
        // ============================================================

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
                // 1. QUICK SETTINGS CARD
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

                        // ------------------------------------------------
                        // Slider 1: Settings / Brightness
                        // ------------------------------------------------

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12

                            Text {
                                text: "settings"
                                color: Colors.grey1
                                font.pixelSize: 18
                                font.family: "Material Symbols Outlined"

                                Layout.preferredWidth: 20
                                horizontalAlignment: Text.AlignHCenter
                            }

                            Rectangle {
                                Layout.fillWidth: true

                                height: 26
                                radius: 13
                                color: Colors.bg2

                                Rectangle {
                                    width: parent.width * 0.75
                                    height: parent.height

                                    radius: 13
                                    color: Colors.green
                                }
                            }
                        }

                        // ------------------------------------------------
                        // Slider 2: Display
                        // ------------------------------------------------

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12

                            Text {
                                text: "desktop_windows"
                                color: Colors.grey1
                                font.pixelSize: 18
                                font.family: "Material Symbols Outlined"

                                Layout.preferredWidth: 20
                                horizontalAlignment: Text.AlignHCenter
                            }

                            Rectangle {
                                Layout.fillWidth: true

                                height: 26
                                radius: 13
                                color: Colors.bg2

                                Rectangle {
                                    width: parent.width * 0.60
                                    height: parent.height

                                    radius: 13
                                    color: Colors.green
                                }
                            }
                        }

                        // ------------------------------------------------
                        // Slider 3: Volume
                        // ------------------------------------------------

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12

                            Text {
                                text: "volume_up"
                                color: Colors.grey1
                                font.pixelSize: 18
                                font.family: "Material Symbols Outlined"

                                Layout.preferredWidth: 20
                                horizontalAlignment: Text.AlignHCenter
                            }

                            Rectangle {
                                Layout.fillWidth: true

                                height: 26
                                radius: 13
                                color: Colors.bg2

                                Rectangle {
                                    width: parent.width * 0.80
                                    height: parent.height

                                    radius: 13
                                    color: Colors.green
                                }
                            }
                        }

                        Item {
                            Layout.preferredHeight: 2
                        }

                        // ====================================================
                        // Wi-Fi & Bluetooth Toggle Buttons
                        // ====================================================

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            // ------------------------------------------------
                            // Wi-Fi Button
                            // ------------------------------------------------

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

                                        color: Colors.green

                                        Text {
                                            anchors.centerIn: parent

                                            text: "wifi"
                                            color: Colors.bg0
                                            font.pixelSize: 18
                                            font.family: "Material Symbols Outlined"
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
                                            font.family: "SF Pro Display"
                                        }

                                        Text {
                                            text: "Aero 5G"
                                            color: Colors.grey1
                                            font.pixelSize: 11
                                            font.family: "SF Pro Display"
                                        }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                }
                            }

                            // ------------------------------------------------
                            // Bluetooth Button
                            // ------------------------------------------------

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

                                        color: Colors.green

                                        Text {
                                            anchors.centerIn: parent

                                            text: "bluetooth"
                                            color: Colors.bg0
                                            font.pixelSize: 18
                                            font.family: "Material Symbols Outlined"
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
                                            font.family: "SF Pro Display"
                                        }

                                        Text {
                                            text: "On"
                                            color: Colors.grey1
                                            font.pixelSize: 11
                                            font.family: "SF Pro Display"
                                        }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                }
                            }
                        }
                    }
                }

                // ====================================================
                // 2. NOTIFICATIONS CARD
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
}