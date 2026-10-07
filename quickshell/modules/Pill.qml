import QtQuick
import QtQuick.Layouts
import qs.theme

Item {
    id: root

    property string icon: ""
    property string label: ""
    property color iconColor: "#3dd1b0"

    property var iconAxes: ({ "FILL": 0, "wght": 400, "GRAD": 0, "opsz": 24 })
    
    property int maxLabelWidth: 400

    implicitHeight: pill.implicitHeight
    implicitWidth: pill.implicitWidth

    // Đặt Shadow ôm khít pill mà không can thiệp logic layout
    Shadow {
        anchors.fill: pill
        z: -1
    }

    Rectangle {
        id: pill

        anchors.fill: parent

        implicitHeight: Theme.moduleHeight
        implicitWidth: labelText.visible
            ? pillIcon.width + Math.min(labelText.implicitWidth, root.maxLabelWidth) + 22
            : pillIcon.width

        radius: height / 2
        color: "#040e0d"

        RowLayout {
            anchors.fill: parent
            spacing: 8

            PillIcon {
                id: pillIcon
                icon: root.icon
                iconColor: root.iconColor
            }

            Text {
                id: labelText

                text: root.label
                color: "#f5e2c5"
                font.family: Theme.font
                font.pixelSize: 14
                elide: Text.ElideRight

                Layout.maximumWidth: root.maxLabelWidth
                Layout.rightMargin: 10

                visible: root.label !== ""
            }
        }
    }
}
