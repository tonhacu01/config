import QtQuick
import QtQuick.Layouts
import qs.modules

Item {
    id: root

    property var theme

    // Mã màu đếm trực tiếp từ ảnh 3
    property color bgSolidColor: "#323826"   // Màu nền tròn ô-liu tối/rêu đặc
    property color iconYellow: "#e5c042"     // Màu icon vàng tươi

    implicitWidth: 30
    implicitHeight: 30

    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight
    Layout.alignment: Qt.AlignVCenter

    Rectangle {
        anchors.centerIn: parent
        width: 30
        height: 30
        radius: width / 2

        // Dùng thẳng màu đặc, KHÔNG dùng Qt.alpha hay opacity
        color: root.bgSolidColor

        Shadow {
            anchors.fill: parent
            z: -1
        }

        Text {
            anchors.centerIn: parent
            text: "tune"
            font.family: "Material Symbols Rounded"
            font.pixelSize: 16

            // Màu vàng của icon
            color: root.iconYellow
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                // control menu
            }
        }
    }
}