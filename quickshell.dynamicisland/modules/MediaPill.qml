import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Services.Mpris
import qs

Hover {
    id: root

    property bool isExpanded: isHovered

    property var player: {
        const players = Mpris.players.values
        return players.find(p => p.isPlaying) ?? players[0] ?? null
    }

    function getArtUrl() {
        if (!player)
            return ""

        const url = player.metadata["xesam:url"] ?? ""
        const match = url.match(/[?&]v=([\w-]{11})/)

        if (match)
            return `https://img.youtube.com/vi/${match[1]}/hqdefault.jpg`

        return player.trackArtUrl || ""
    }

    function formatTime(seconds) {
        if (!seconds || seconds < 0)
            return "0:00"

        const minutes = Math.floor(seconds / 60)
        const secs = Math.floor(seconds % 60)

        return minutes + ":" + (secs < 10 ? "0" : "") + secs
    }

    width: isExpanded ? 320 : 36
    height: isExpanded ? 160 : 36

    Behavior on width {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    RectangularShadow {
        anchors.fill: parent
        radius: 20
        blur: 18
        spread: 2
        offset.x: 0
        offset.y: 4
        color: Qt.rgba(0, 0, 0, 0.45)
        cached: true
    }

    Rectangle {
        anchors.fill: parent
        radius: 20
        color: Colors.bg0
        border.color: root.isExpanded ? Colors.bg2 : "transparent"
        border.width: 1
    }

    Text {
        anchors.centerIn: parent
        visible: !root.isExpanded
        text: root.player ? "music_note" : "music_off"
        color: Colors.fg
        font {
            family: "Material Symbols Outlined"
            pixelSize: 20
        }
    }

    Item {
        anchors.fill: parent
        anchors.margins: 12
        visible: root.isExpanded
        opacity: visible ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }

        RowLayout {
            anchors.fill: parent
            spacing: 16

            Rectangle {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 100
                radius: 12
                color: Colors.bg1
                clip: true

                Image {
                    id: albumArt
                    anchors.fill: parent
                    source: root.getArtUrl()
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    cache: true
                }

                Text {
                    anchors.centerIn: parent
                    visible: !root.player || albumArt.status !== Image.Ready
                    text: "music_note"
                    color: Colors.grey1
                    font {
                        family: "Material Symbols Outlined"
                        pixelSize: 28
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 7

                Text {
                    Layout.fillWidth: true
                    text: root.player ? root.player.trackTitle : "Nothing playing"
                    color: Colors.fg
                    font {
                        family: "SF Pro Display"
                        pixelSize: 13
                        bold: true
                    }
                    elide: Text.ElideRight
                }

                Text {
                    Layout.fillWidth: true
                    text: root.player ? root.player.trackArtist : "No media"
                    color: Colors.grey2
                    font {
                        family: "SF Pro Display"
                        pixelSize: 11
                    }
                    elide: Text.ElideRight
                }

                Text {
                    Layout.fillWidth: true
                    text: root.player ? root.player.trackAlbum : ""
                    color: Colors.grey1
                    font {
                        family: "SF Pro Display"
                        pixelSize: 10
                    }
                    elide: Text.ElideRight
                }

                Item {
                    Layout.fillHeight: true
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 3
                    radius: 1.5
                    color: Colors.bg3

                    Rectangle {
                        width: root.player && root.player.length > 0
                               ? Math.max(0, Math.min(1, root.player.position / root.player.length)) * parent.width
                               : 0
                        height: parent.height
                        radius: 1.5
                        color: Colors.green
                    }
                }

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: root.player ? root.formatTime(root.player.position) : "0:00"
                        color: Colors.grey1
                        font {
                            family: "SF Pro Display"
                            pixelSize: 9
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        text: root.player ? root.formatTime(root.player.length) : "0:00"
                        color: Colors.grey1
                        font {
                            family: "SF Pro Display"
                            pixelSize: 9
                        }
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 20

                    Text {
                        text: "skip_previous"
                        color: root.player ? Colors.fg : Colors.grey0
                        font {
                            family: "Material Symbols Outlined"
                            pixelSize: 18
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: root.player !== null
                            onClicked: root.player?.previous()
                        }
                    }

                    Rectangle {
                        width: 28
                        height: 28
                        radius: 14
                        color: root.player ? Colors.green : Colors.bg3

                        Text {
                            anchors.centerIn: parent
                            text: !root.player
                                  ? "play_arrow"
                                  : root.player.isPlaying
                                    ? "pause"
                                    : "play_arrow"
                            color: root.player ? Colors.bg0 : Colors.grey1
                            font {
                                family: "Material Symbols Outlined"
                                pixelSize: 18
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: root.player !== null
                            onClicked: root.player?.togglePlaying()
                        }
                    }

                    Text {
                        text: "skip_next"
                        color: root.player ? Colors.fg : Colors.grey0
                        font {
                            family: "Material Symbols Outlined"
                            pixelSize: 18
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: root.player !== null
                            onClicked: root.player?.next()
                        }
                    }
                }
            }
        }
    }
}