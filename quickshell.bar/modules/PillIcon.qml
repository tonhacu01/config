import QtQuick
import qs.theme

//
// The lighter square at the left end of a module.
// Holds one Material Symbols icon with a matching tinted background.
Rectangle {
    id: root

    property string icon: ""
    property color iconColor: Theme.text
    property real iconBgOpacity: 0.15

    

    property real nudge: 0

    width: height
    height: parent.height

    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left

    anchors.topMargin: 3
    anchors.bottomMargin: 3
    anchors.leftMargin: 3

    // Tinted background matching icon color
    color: Qt.alpha(root.iconColor, root.iconBgOpacity)
    radius: height / 2

    Text {
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: root.nudge

        text: root.icon
        color: root.iconColor
        font.family: Theme.iconFont
        font.pixelSize: Theme.iconSize
        font.variableAxes: Theme.iconAxes
    }
}