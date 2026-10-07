import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Mpris


PanelWindow {

    id: bar

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 35
    color: bg1


    // =========================================================
    // ARIADNE COLORS
    // =========================================================

    property color bg0: "#040e0d"
    property color bg1: "#0a1816"
    property color bg2: "#0f211f"
    property color bg3: "#152a26"
    property color bg4: "#1d3631"

    property color fg: "#fafafacc"

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


    // =========================================================
    // ICONS
    // =========================================================

    property string iconBluetooth: "bluetooth"
    property string iconWifi: "wifi"
    property string iconBattery: "battery_android_full"
    property string iconVolume: "volume_up"
    property string iconMedia: "music_note"
    property string iconClock: "nest_clock_farsight_analog"


    // =========================================================
    // BACKGROUND
    // =========================================================

    Rectangle {
        anchors.fill: parent
        color: bar.bg1
        z: -1
    }


    // =========================================================
    // CLOCK
    // =========================================================

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }


    // =========================================================
    // LEFT
    // MPRIS
    // =========================================================

    RowLayout {
        id: left

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }

        height: 35
        spacing: 6

        property var player:
            Mpris.players.values.length > 0
            ? Mpris.players.values[0]
            : null


        // =====================================================
        // MEDIA ICON
        // =====================================================

        Rectangle {
            id: mediaIconBox

            visible: left.player !== null

            width: 35
            height: 35

            color: bar.bg0

            Text {
                anchors.centerIn: parent

                text: bar.iconMedia

                font.family: "Material Symbols Rounded"
                font.pixelSize: 14
                font.weight: Font.Normal

                color: bar.aqua
            }
        }


        // =====================================================
        // MEDIA TITLE
        // =====================================================

        Text {
            id: mediaText

            visible: left.player !== null

            Layout.maximumWidth: 250

            text: {
                if (!left.player)
                    return ""

                return left.player.trackTitle || ""
            }

            elide: Text.ElideRight

            font.family: "Iosevka Nerd Font"
            font.pixelSize: 14
            font.weight: Font.Normal

            color: bar.fg

            verticalAlignment: Text.AlignVCenter

            Layout.fillWidth: true
        }


        // =====================================================
        // MPRIS MOUSE AREA
        // =====================================================

        MouseArea {
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: mediaIconBox.left
                right: mediaText.right
            }

            onClicked: {
                if (left.player)
                    left.player.togglePlaying()
            }

            onWheel: function(event) {
                if (!left.player)
                    return

                if (event.angleDelta.y > 0)
                    left.player.next()
                else
                    left.player.previous()
            }
        }
    }


    // =========================================================
    // CENTER
    // CLOCK + WORKSPACES
    // =========================================================

    Row {
        id: center

        anchors.centerIn: parent

        height: 35
        spacing: 6


        // =====================================================
        // CLOCK ICON
        // =====================================================

        Rectangle {
            id: clockIconBox

            width: 35
            height: 35

            color: bar.bg0

            Text {
                anchors.centerIn: parent

                text: bar.iconClock

                font.family: "Material Symbols Rounded"
                font.pixelSize: 14
                font.weight: Font.Normal

                color: bar.purple
            }
        }


        // =====================================================
        // CLOCK
        // =====================================================

        Text {
            height: 35

            verticalAlignment: Text.AlignVCenter

            text: Qt.formatDateTime(
                clock.date,
                "hh:mm"
            )

            font.family: "Iosevka Nerd Font"
            font.pixelSize: 14
            font.weight: Font.Normal

            color: bar.fg

            leftPadding: 6
            rightPadding: 6
        }


        // =====================================================
        // WORKSPACE PILL
        // =====================================================

        Rectangle {
            id: workspacePill

            implicitWidth: workspaceRow.implicitWidth + 40
            implicitHeight: 30

            radius: height / 2

            color: "transparent"


            RowLayout {
                id: workspaceRow

                anchors.centerIn: parent

                spacing: 20


                Repeater {
                    model: 5


                    Rectangle {
                        required property int index


                        property var workspace:
                            Hyprland.workspaces.values.find(
                                w => w.id === index + 1
                            )


                        implicitWidth:
                            workspace?.active
                            ? 11
                            : 6

                        implicitHeight:
                            implicitWidth

                        radius: width / 2

                        color:
                            workspace?.active
                            ? "transparent"
                            : "#ffffff"

                        border.width:
                            workspace?.active
                            ? 3.25
                            : 0

                        border.color:
                            bar.aqua


                        Behavior on implicitWidth {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.OutCubic
                            }
                        }


                        Behavior on border.width {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.OutCubic
                            }
                        }


                        MouseArea {
                            anchors.fill: parent

                            cursorShape:
                                Qt.PointingHandCursor

                            onClicked: {
                                Hyprland.dispatch(
                                    "workspace "
                                    + (index + 1)
                                )
                            }
                        }
                    }
                }
            }
        }
    }


    // =========================================================
    // RIGHT
    // =========================================================

    RowLayout {
        id: right

        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        height: 35
        spacing: 8


        // =====================================================
        // VOLUME
        // =====================================================

        RowLayout {
            spacing: 4
            Layout.rightMargin: 4


            Rectangle {
                width: 35
                height: 35

                color: bar.bg0

                Text {
                    anchors.centerIn: parent

                    text: bar.iconVolume

                    font.family: "Material Symbols Rounded"
                    font.pixelSize: 14
                    font.weight: Font.Normal

                    color: bar.aqua
                }
            }


            Text {
                text: "100%"

                font.family: "Iosevka Nerd Font"
                font.pixelSize: 14
                font.weight: Font.Normal

                color: bar.fg
            }
        }


        // =====================================================
        // BATTERY
        // =====================================================

        RowLayout {
            spacing: 4
            Layout.rightMargin: 4


            Rectangle {
                width: 35
                height: 35

                color: bar.bg0

                Text {
                    anchors.centerIn: parent

                    text: bar.iconBattery

                    font.family: "Material Symbols Rounded"
                    font.pixelSize: 14
                    font.weight: Font.Normal

                    color: bar.green
                }
            }


            Text {
                text: "100%"

                font.family: "Iosevka Nerd Font"
                font.pixelSize: 14
                font.weight: Font.Normal

                color: bar.fg
            }
        }


        // =====================================================
        // BLUETOOTH
        // =====================================================

        RowLayout {
            spacing: 4
            Layout.rightMargin: 4


            Rectangle {
                width: 35
                height: 35

                color: bar.bg0

                Text {
                    anchors.centerIn: parent

                    text: bar.iconBluetooth

                    font.family: "Material Symbols Rounded"
                    font.pixelSize: 14
                    font.weight: Font.Normal

                    color: bar.yellow
                }
            }


            Text {
                text: "TWS"

                font.family: "Iosevka Nerd Font"
                font.pixelSize: 14
                font.weight: Font.Normal

                color: bar.fg
            }
        }


        // =====================================================
        // WIFI
        // =====================================================

        RowLayout {
            spacing: 4
            Layout.rightMargin: 10


            Rectangle {
                width: 35
                height: 35

                color: bar.bg0

                Text {
                    anchors.centerIn: parent

                    text: bar.iconWifi

                    font.family: "Material Symbols Rounded"
                    font.pixelSize: 14
                    font.weight: Font.Normal

                    color: bar.red
                }
            }


            Text {
                text: "Authentical 5G"

                font.family: "Iosevka Nerd Font"
                font.pixelSize: 14
                font.weight: Font.Normal

                color: bar.fg
            }
        }
    }
}