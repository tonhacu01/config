import QtQuick
import qs.modules

Item {
    id: root

    property var theme
    property var iconBgOpacity: 0.5
    property var iconColor: root.theme.bgBase


    implicitWidth: 30
    implicitHeight: 30

    Rectangle {
        anchors.fill: parent

        radius: width / 2

        color: Qt.alpha(root.iconColor, root.iconBgOpacity)

        Shadow {
            anchors.fill: parent
            z: -1
        }

        Text {
            anchors.centerIn: parent

            text: ""

            font.family: "Iosevka Nerd Font"
            font.pixelSize: 13

            color: root.theme.accentPrimary
        }

        MouseArea {
            anchors.fill: parent

            cursorShape: Qt.PointingHandCursor

            onClicked: {
                // menu sau
            }
        }
    }
}