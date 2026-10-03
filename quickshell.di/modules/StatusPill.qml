import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import qs


Hover {
    id: root

    property bool isExpanded: isHovered

    width: isExpanded ? 470 : 36
    height: isExpanded ? 490 : 36

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
        radius: 24
        blur: 18
        spread: 2
        offset.x: 0
        offset.y: 4
        color: Qt.rgba(0, 0, 0, 0.45)
        cached: true
    }

    Rectangle {
        id: bgCard
        anchors.fill: parent
        radius: 24
        color: Colors.bg0

        Canvas {
            id: customBorder
            anchors.fill: parent
            visible: !root.isExpanded

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();

                var cx = width / 2;
                var cy = height / 2;
                var r = (width / 2) - 2; // Border circle radius
                var strokeCol = Colors.aqua;

                ctx.lineWidth = 2;
                ctx.strokeStyle = strokeCol;
                ctx.fillStyle = strokeCol;

                // 1. Draw solid arc on the TOP part (from ~35 degrees to 145 degrees)
                // In Canvas: 0 rad points to 3 o'clock, Math.PI/2 points to 6 o'clock (bottom)
                var gapStart = Math.PI * 0.22; // Gap starts at the bottom
                var gapEnd = Math.PI * 0.78;   // Gap ends at the bottom

                ctx.beginPath();
                ctx.arc(cx, cy, r, gapEnd, gapStart + 2 * Math.PI, false);
                ctx.stroke();

                // 2. Draw 5 evenly spaced dots inside the gap at the BOTTOM
                var dotCount = 5;
                var step = (gapEnd - gapStart) / (dotCount - 1);

                for (var i = 0; i < dotCount; i++) {
                    var angle = gapStart + (i * step);
                    var x = cx + r * Math.cos(angle);
                    var y = cy + r * Math.sin(angle);

                    ctx.beginPath();
                    ctx.arc(x, y, 1.2, 0, 2 * Math.PI); // Each dot radius = 1.2px
                    ctx.fill();
                }
            }

            Connections {
                target: root
                function onIsExpandedChanged() { customBorder.requestPaint(); }
            }
        }

        // Rounded border shown when expanded
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.color: Colors.bg1
            border.width: 2
            visible: root.isExpanded
        }
    }

    Text {
        anchors.centerIn: parent
        visible: !root.isExpanded
        text: "wifi"
        color: Colors.fg
        font {
            family: "Material Symbols Sharp"
            pixelSize: 16
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 14
        visible: root.isExpanded
        opacity: visible ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            ControlCard {
                icon: "wifi"
                title: "Wi-Fi"
                subtitle: "Atlantis 5G"
                cardColor: Colors.bg1
                iconBackground: Colors.green
                iconColor: Colors.bg0
            }

            ControlCard {
                icon: "do_not_disturb_on"
                title: "Focus"
                subtitle: "Off"
                cardColor: Colors.bg1
            }

            Rectangle {
                Layout.preferredWidth: 44
                Layout.preferredHeight: 58
                radius: 20
                color: Colors.bg1

                Text {
                    anchors.centerIn: parent
                    text: "lock"
                    color: Colors.fg
                    font {
                        family: "Material Symbols Outlined"
                        pixelSize: 18
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            ControlCard {
                icon: "bluetooth"
                title: "Bluetooth"
                subtitle: "On"
                cardColor: Colors.bg1
                iconBackground: Colors.green
                iconColor: Colors.bg0
            }

            ControlCard {
                icon: "sports_esports"
                title: "Game Mode"
                subtitle: "Off"
                cardColor: Colors.bg1
            }

            Rectangle {
                Layout.preferredWidth: 44
                Layout.preferredHeight: 58
                radius: 20
                color: Colors.bg1

                Text {
                    anchors.centerIn: parent
                    text: "bedtime"
                    color: Colors.fg
                    font {
                        family: "Material Symbols Outlined"
                        pixelSize: 18
                    }
                }
            }
        }

        SliderCard {
            title: "Sound"
            icon: "volume_up"
            value: 0.6
        }

        SliderCard {
            title: "Display"
            icon: "wb_sunny"
            value: 0.35
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 20
            color: Colors.bg1

            Column {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Text {
                    text: "Notifications"
                    color: Colors.grey2
                    font {
                        family: "SF Pro Display"
                        pixelSize: 12
                        bold: true
                    }
                }

                Text {
                    text: "No notifications"
                    color: Colors.grey1
                    font {
                        family: "SF Pro Display"
                        pixelSize: 11
                    }
                }
            }
        }
    }
}