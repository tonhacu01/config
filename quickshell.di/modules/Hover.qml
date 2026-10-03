// Hover.qml
import QtQuick

Item {
    id: root

    // ==============================
    // CONFIGURATION PROPERTIES
    // ==============================
    property real normalWidth: 80
    property real normalHeight: 35

    property real hoverWidth: 96
    property real hoverHeight: 42

    property real expandedWidth: 220
    property real expandedHeight: 100

    property bool isExpanded: false
    property int duration: 250
    property alias mouseArea: mouseArea
    property bool isHovered: mouseArea.containsMouse

    // Logic kích thước:
    // 1. Nếu đang mở rộng (Click/Active) -> Lấy expandedWidth
    // 2. Nếu đang Hover -> Lấy hoverWidth (nảy nhẹ)
    // 3. Bình thường -> Lấy normalWidth
    width: isExpanded ? expandedWidth : (isHovered ? hoverWidth : normalWidth)
    height: isExpanded ? expandedHeight : (isHovered ? hoverHeight : normalHeight)

    Behavior on width {
        NumberAnimation {
            duration: root.duration
            easing.type: Easing.OutBack
            easing.overshoot: 1.2
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: root.duration
            easing.type: Easing.OutBack
            easing.overshoot: 1.2
        }
    }

    // ==============================
    // INTERACTION AREA
    // ==============================
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
    }
}