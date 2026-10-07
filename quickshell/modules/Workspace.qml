import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs 

Rectangle {
    id: root

    implicitWidth: row.implicitWidth + 30
    implicitHeight: 30
    radius: height / 2
    color: "#040e0d"

    // ─────────────────────────────────────────────
    // Shadow for Workspace
    // ─────────────────────────────────────────────
    Shadow {
        anchors.fill: parent
        z: -1
    }

    property int activeIndex: {
        let activeWs = Hyprland.workspaces.values.find(w => w.active)
        return activeWs ? activeWs.id - 1 : 0
    }

    Item {
        id: container
        anchors.centerIn: parent
        width: row.implicitWidth
        height: row.implicitHeight

        // 1. SLIDING ACTIVE INDICATOR (Outer ring + Aqua dot)
        Item {
            id: activeIndicator
            width: 16
            height: 16
            z: 2

            anchors.verticalCenter: parent.verticalCenter
            x: root.activeIndex * (16 + row.spacing)

            // Smooth sliding animation
            Behavior on x {
                NumberAnimation {
                    duration: 280
                    easing.type: Easing.OutCubic
                }
            }

            // Outer soft tint ring
            Rectangle {
                anchors.centerIn: parent
                width: 16
                height: 16
                radius: width / 2
                color: Qt.alpha(Colors.aqua, 0.25)
            }

            // Inner solid aqua dot
            Rectangle {
                anchors.centerIn: parent
                width: 8
                height: 8
                radius: width / 2
                color: Colors.aqua
            }
        }

        // 2. STATIC INACTIVE DOTS
        RowLayout {
            id: row
            anchors.fill: parent
            spacing: 12
            z: 1

            Repeater {
                model: 5

                Item {
                    required property int index

                    property var workspace: Hyprland.workspaces.values.find(
                        w => w.id === index + 1
                    )
                    property bool isActive: index === root.activeIndex

                    implicitWidth: 16
                    implicitHeight: 16

                    // Inactive dot
                    Rectangle {
                        anchors.centerIn: parent
                        width: 6
                        height: 6
                        radius: width / 2

                        // Hide inactive dot when indicator slides over it
                        opacity: parent.isActive ? 0 : 1
                        color: parent.workspace ? "#f5e6d3" : "#1a2b28"

                        Behavior on opacity {
                            NumberAnimation { duration: 150 }
                        }
                    }
                }
            }
        }
    }
}