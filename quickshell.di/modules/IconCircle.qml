import QtQuick

Rectangle {
    property string icon: ""
    property color iconColor: Colors.fg
    property color backgroundColor: Colors.bg3
    property int size: 36
    property int iconSize: 18

    width: size
    height: size
    radius: size / 2
    color: backgroundColor

    Text {
        anchors.centerIn: parent
        text: parent.parent.icon
        color: parent.parent.iconColor
        font {
            family: "Material Symbols Rounded"
            pixelSize: parent.parent.iconSize
        }
    }
}