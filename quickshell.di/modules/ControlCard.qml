
import QtQuick
import QtQuick.Layouts
import qs

Rectangle {
    id: root

    property string icon: ""
    property string title: ""
    property string subtitle: ""
    property color iconColor: Colors.fg
    property color iconBackground: Colors.bg3
    property color cardColor: Colors.bg1

    Layout.fillWidth: true
    Layout.preferredHeight: 58
    radius: 20
    color: root.cardColor

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 12

        Rectangle {
            width: 36
            height: 36
            radius: 18
            color: root.iconBackground

            Text {
                anchors.centerIn: parent
                text: root.icon
                color: root.iconColor
                font {
                    family: "Material Symbols Outlined"
                    pixelSize: 18
                }
            }
        }

        Column {
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: root.title
                color: Colors.fg
                font {
                    family: "SF Pro Display"
                    pixelSize: 13
                    bold: true
                }
            }

            Text {
                text: root.subtitle
                color: Colors.grey2
                font {
                    family: "SF Pro Display"
                    pixelSize: 11
                }
            }
        }
    }
}

