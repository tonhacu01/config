import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import qs

Hover {
    id: root

    // Trạng thái hiển thị: 0 = Normal/Hover, 1 = Week View, 2 = Month View
    property int viewMode: 0

    // Ngày đang hiển thị trên lịch (Mặc định là ngày hiện tại)
    property date displayDate: clockTimer.currentTime

    // ==========================================
    // CẤU HÌNH KÍCH THƯỚC DỄ DÀNG CHỈNH SỬA
    // ==========================================
    normalWidth: 80
    normalHeight: 35

    hoverWidth: 96
    hoverHeight: 42

    // State 1 (Week View) & State 2 (Month View)
    expandedWidth: viewMode === 1 ? 300 : 300
    expandedHeight: viewMode === 1 ? 120 : 280

    // Bật trạng thái expanded cho Hover.qml khi ở state 1 hoặc 2
    isExpanded: viewMode !== 0

    anchors {
        top: parent.top
        horizontalCenter: parent.horizontalCenter
        topMargin: 15
    }

    // Shadow background
    RectangularShadow {
        anchors.fill: background
        radius: background.radius
        blur: 18
        spread: 2
        offset.x: 0
        offset.y: 4
        color: Qt.rgba(0, 0, 0, 0.45)
        cached: true
    }

    // Background chính với Radius thay đổi linh hoạt theo State
    Rectangle {
        id: background
        anchors.fill: parent
        color: Colors.bg0
        clip: true // Khống chế chống tràn nội dung ra ngoài

        radius: {
            if (root.viewMode === 1) return 30   // State 1: Week View
            if (root.viewMode === 2) return 30   // State 2: Month View
            return 30                  // State 0: Normal / Hover (Pill Shape)
        }

        Behavior on radius {
            NumberAnimation {
                duration: root.duration
                easing.type: Easing.OutCubic
            }
        }
    }

    // ==========================================
    // 0. VIEW NORMAL / HOVER (Giờ thu gọn hh:mm)
    // ==========================================
    Text {
        anchors.centerIn: parent
        visible: root.viewMode === 0
        opacity: visible ? 1 : 0
        color: Colors.fg
        font {
            family: "SF Pro Display"
            pixelSize: root.isHovered ? 16 : 14
            bold: true
        }
        text: Qt.formatDateTime(clockTimer.currentTime, "hh:mm")

        Behavior on opacity { NumberAnimation { duration: 150 } }
        Behavior on font.pixelSize { NumberAnimation { duration: 150 } }
    }

    // ==========================================
    // 1. VIEW WEEK (Click 1 Lần)
    // ==========================================
    Item {
        anchors.fill: parent
        visible: root.viewMode === 1
        opacity: visible ? 1 : 0

        Behavior on opacity { NumberAnimation { duration: 200 } }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 6

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: Qt.formatDateTime(clockTimer.currentTime, "hh:mm")
                color: Colors.fg
                font { family: "SF Pro Display"; pixelSize: 22; bold: true }
            }

            Row {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                Repeater {
                    model: 7

                    delegate: Item {
                        width: 24
                        height: 40

                        property var dayDate: {
                            var d = new Date(clockTimer.currentTime)
                            d.setDate(d.getDate() + (index - 3))
                            return d
                        }
                        
                        // Distance from Today (Index 3 là hôm nay)
                        property int distFromToday: Math.abs(index - 3) 
                        property bool isToday: distFromToday === 0

                        // Mức độ tan biến (Fade Out)
                        property real dayOpacity: {
                            if (isToday) return 1.0
                            if (distFromToday === 1) return 0.75   // Hôm qua / Ngày mai
                            if (distFromToday === 2) return 0.45   // Cách 2 ngày
                            return 0.25                            // Cách 3 ngày (rìa ngoài)
                        }

                        Column {
                            anchors.centerIn: parent
                            spacing: 4
                            opacity: parent.dayOpacity

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: Qt.formatDateTime(dayDate, "ddd").toUpperCase()
                                color: isToday ? (dayDate.getDay() === 0 ? Colors.red : Colors.fg) : Colors.grey2
                                font { family: "SF Pro Display"; pixelSize: 10; bold: true }
                            }

                            Rectangle {
                                width: 22
                                height: 22
                                radius: 11
                                color: isToday ? Colors.aqua : "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: dayDate.getDate()
                                    color: isToday ? Colors.bg0 : (parent.parent.distFromToday === 1 ? Colors.grey1 : Colors.fg)
                                    font { family: "SF Pro Display"; pixelSize: 12; bold: true }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // ==========================================
    // 2. VIEW MONTH CALENDAR (Double Click)
    // ==========================================
    Item {
        anchors.fill: parent
        anchors.margins: 16
        visible: root.viewMode === 2
        opacity: visible ? 1 : 0

        Behavior on opacity { NumberAnimation { duration: 200 } }

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            // Tiêu đề Tháng & Năm
            RowLayout {
                Layout.fillWidth: true

                Rectangle {
                    width: 28; height: 28; radius: 14; color: Colors.bg1
                    Text { anchors.centerIn: parent; text: "←"; color: Colors.fg }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var d = new Date(root.displayDate)
                            d.setMonth(d.getMonth() - 1)
                            root.displayDate = d
                        }
                    }
                }

                Text {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: Qt.formatDateTime(root.displayDate, "MMMM yyyy")
                    color: Colors.fg
                    font { family: "SF Pro Display"; pixelSize: 16; bold: true }
                }

                Rectangle {
                    width: 28; height: 28; radius: 14; color: Colors.bg1
                    Text { anchors.centerIn: parent; text: "→"; color: Colors.fg }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var d = new Date(root.displayDate)
                            d.setMonth(d.getMonth() + 1)
                            root.displayDate = d
                        }
                    }
                }
            }

            // Hàng tên thứ trong tuần
            Row {
                Layout.alignment: Qt.AlignHCenter
                spacing: 14

                Repeater {
                    model: ["S", "M", "T", "W", "T", "F", "S"]
                    Text {
                        width: 20
                        horizontalAlignment: Text.AlignHCenter
                        text: modelData
                        color: index === 0 ? Colors.red : Colors.grey2
                        font { family: "SF Pro Display"; pixelSize: 12; bold: true }
                    }
                }
            }

            // Lưới 42 ô lịch
            Grid {
                Layout.alignment: Qt.AlignHCenter
                columns: 7
                spacing: 6

                Repeater {
                    model: 42

                    delegate: Item {
                        width: 28
                        height: 28

                        property date dateObj: {
                            var base = root.displayDate
                            var firstDay = new Date(base.getFullYear(), base.getMonth(), 1)
                            var startOffset = firstDay.getDay()
                            return new Date(base.getFullYear(), base.getMonth(), 1 - startOffset + index)
                        }

                        property bool isCurrentMonth: dateObj.getMonth() === root.displayDate.getMonth()

                        // Tính khoảng cách ngày so với hôm nay
                        property int dayDiff: {
                            var now = clockTimer.currentTime
                            var today = new Date(now.getFullYear(), now.getMonth(), now.getDate())
                            var current = new Date(dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate())
                            var diffTime = Math.abs(current - today)
                            return Math.round(diffTime / (1000 * 60 * 60 * 24))
                        }

                        property bool isToday: dayDiff === 0

                        // Tính mức độ Opacity tan biến xung quanh ngày hôm nay
                        property real itemOpacity: {
                            if (!isCurrentMonth) return 0.15          // Khác tháng: mờ hẳn
                            if (isToday) return 1.0                   // Rõ nhất
                            if (dayDiff === 1) return 0.75            // Hôm qua / Ngày mai
                            if (dayDiff === 2) return 0.50            // Cách 2 ngày
                            if (dayDiff === 3) return 0.35            // Cách 3 ngày
                            return 0.25                               // Các ngày xa hơn
                        }

                        Rectangle {
                            anchors.fill: parent
                            radius: 14
                            color: isToday ? Colors.aqua : "transparent"
                            opacity: parent.itemOpacity

                            Text {
                                anchors.centerIn: parent
                                text: dateObj.getDate()
                                color: isToday ? Colors.bg0 : (parent.parent.dayDiff === 1 ? Colors.grey1 : Colors.fg)
                                font {
                                    family: "SF Pro Display"
                                    pixelSize: 13
                                    bold: isToday
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // ==========================================
    // CONTROL HOVER & LEAVE MOUSE
    // ==========================================
    Connections {
        target: root.mouseArea

        function onContainsMouseChanged() {
            if (!root.mouseArea.containsMouse) {
                root.viewMode = 0
                root.displayDate = clockTimer.currentTime
            }
        }

        function onClicked() {
            if (root.viewMode === 0) {
                root.viewMode = 1
            } else if (root.viewMode === 1) {
                root.viewMode = 0
            }
        }

        function onDoubleClicked() {
            if (root.viewMode !== 2) {
                root.viewMode = 2
            } else {
                root.viewMode = 0
            }
        }
    }

    Timer {
        id: clockTimer
        property date currentTime: new Date()
        interval: 1000
        running: true
        repeat: true
        onTriggered: currentTime = new Date()
    }
}