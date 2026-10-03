import QtQuick
import QtQuick.Layouts
import qs

Rectangle {
    id: root

    property string title: ""
    property string icon: ""
    property real value: 0.5

    Layout.fillWidth: true
    Layout.preferredHeight: 58
    radius: 20
    color: Colors.bg1

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 12

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: root.title
                    color: Colors.fg
                    font {
                        family: "SF Pro Display"
                        pixelSize: 12
                        bold: true
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    text: "chevron_right"
                    color: Colors.grey2
                    font {
                        family: "Material Symbols Outlined"
                        pixelSize: 14
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 24
                radius: 12
                color: Colors.bg3

                Rectangle {
                    width: parent.width * root.value
                    height: parent.height
                    radius: 12
                    color: Colors.green

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        text: root.icon
                        color: Colors.bg0
                        font {
                            family: "Material Symbols Outlined"
                            pixelSize: 14
                        }
                    }
                }
            }
        }
    }
}
